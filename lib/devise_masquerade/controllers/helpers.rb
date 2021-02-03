module DeviseMasquerade
  module Controllers
    module Helpers
      def self.define_helpers(mapping)
        name = mapping.name
        class_name = mapping.class_name

        class_eval <<-METHODS, __FILE__, __LINE__ + 1
          def masquerade!
            return if params["#{Devise.masquerade_param}"].blank?

            klass = unless params[:masqueraded_resource_class].blank?
              params[:masqueraded_resource_class].constantize
            else
              if Devise.masqueraded_resource_class
                Devise.masqueraded_resource_class
              elsif defined?(User)
                User
              end
            end
            return unless klass

            resource = GlobalID::Locator.locate_signed params[Devise.masquerade_param], for: 'masquerade'

            if resource
              masquerade_sign_in(resource)
            end
          end

          def masquerade_#{name}!
            return if params["#{Devise.masquerade_param}"].blank?

            resource = GlobalID::Locator.locate_signed params[Devise.masquerade_param], for: 'masquerade'

            if resource
              masquerade_sign_in(resource)
            end
          end

          def #{name}_masquerade?
            ::Rails.cache.exist?(:"devise_masquerade_#{name}").present?
          end

          def #{name}_masquerade_owner
            return nil unless send(:#{name}_masquerade?)
            GlobalID::Locator.locate_signed(Rails.cache.read(:"devise_masquerade_#{name}"), for: 'masquerade')
          end

          private

          def masquerade_sign_in(resource)
            if Devise.masquerade_bypass_warden_callback
              if respond_to?(:bypass_sign_in)
                bypass_sign_in(resource)
              else
                sign_in(resource, bypass: true)
              end
            else
              sign_in(resource)
            end
          end
        METHODS

        ActiveSupport.on_load(:action_controller) do
          if respond_to?(:helper_method)
            helper_method "#{name}_masquerade?"
            helper_method "#{name}_masquerade_owner"
          end
        end
      end
    end
  end
end
