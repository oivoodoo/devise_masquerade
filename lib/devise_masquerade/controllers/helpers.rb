module DeviseMasquerade
  module Controllers
    module Helpers
      def self.define_helpers(mapping)
        name = mapping.name
        class_name = mapping.class_name

        class_eval <<-METHODS, __FILE__, __LINE__ + 1
          def masquerade_#{name}!
            return if params[:masquerade].blank?

            #{name} = ::#{class_name}.find_by_masquerade_key(params[:masquerade])

            sign_in(#{name}, :bypass => Devise.masquerade_bypass_warden_callback) if #{name}
          end

          def #{name}_masquerade?
            session[:"devise_masquerade_#{name}"].present?
          end

          def #{name}_masquerade_owner
            return nil unless send(:#{name}_masquerade?)
            ::#{class_name}.to_adapter.find_first(:id => session[:"devise_masquerade_#{name}"])
          end
        METHODS

        ActiveSupport.on_load(:action_controller) do
          helper_method "#{name}_masquerade?"
          helper_method "#{name}_masquerade_owner"
        end
      end
    end
  end
end

ActionController::Base.send(:include, DeviseMasquerade::Controllers::Helpers)
