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
              if Devise.masqueraded_resource_class_name.present?
                Devise.masqueraded_resource_class_name.constantize
              elsif Devise.masqueraded_resource_class
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
            return false if current_#{name}.blank?
            return false if session[#{name}_helper_session_key].blank?

            if Devise.masquerade_storage_method_session?
              session[#{name}_helper_session_key].present?
            else
              ::Rails.cache.exist?(#{name}_helper_session_key).present?
            end
          end

          def #{name}_masquerade_owner
            return unless send(:#{name}_masquerade?)

            if Devise.masquerade_storage_method_session?
              resource_id = session[#{name}_helper_session_key]

              masquerade_owner_class.find(resource_id)
            else
              sgid = ::Rails.cache.read(#{name}_helper_session_key)

              GlobalID::Locator.locate_signed(sgid, for: 'masquerade')
            end
          end

          private

          def #{name}_helper_session_key
            ["devise_masquerade_#{name}", current_#{name}.id, #{name}_helper_masquerading_resource_guid].join("_")
          end

          def #{name}_helper_masquerading_resource_guid
            session["devise_masquerade_masquerading_resource_guid"].to_s
          end

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

          def masqueraded_resource_class
            @masqueraded_resource_class ||= begin
              unless params[:masqueraded_resource_class].blank?
                params[:masqueraded_resource_class].constantize
              else
                unless session[session_key_masqueraded_resource_class].blank?
                  session[session_key_masqueraded_resource_class].constantize
                else
                  if Devise.masqueraded_resource_class_name.present?
                    Devise.masqueraded_resource_class_name.constantize
                  else
                    Devise.masqueraded_resource_class || resource_class
                  end
                end
              end
            end
          end

          def session_key_masqueraded_resource_class
            "devise_masquerade_masqueraded_resource_class"
          end

          def session_key_masquerading_resource_class
            "devise_masquerade_masquerading_resource_class"
          end

          def session_key_masquerading_resource_guid
            "devise_masquerade_masquerading_resource_guid"
          end

        METHODS

        ActiveSupport.on_load(:action_controller) do
          if respond_to?(:helper_method)
            helper_method "#{name}_masquerade?"
            helper_method "#{name}_masquerade_owner"

            helper_method :masqueraded_resource_class
            helper_method :session_key_masqueraded_resource_class
            helper_method :session_key_masquerading_resource_class
            helper_method :session_key_masquerading_resource_guid
          end
        end
      end

      # The session stores the owner's id. Resolve that id against the owner
      # model saved at masquerade time, not the model currently signed in.
      # Only classes registered with Devise are accepted from the session.
      def masquerade_owner_class
        from_session = devise_class_for(session[session_key_masquerading_resource_class])
        return from_session if from_session

        if Devise.masquerading_resource_class_name.present?
          devise_class_for(Devise.masquerading_resource_class_name) ||
            Devise.masquerading_resource_class_name.constantize
        elsif Devise.masquerading_resource_class
          Devise.masquerading_resource_class
        else
          resource_class
        end
      end

      def devise_class_for(class_name)
        return if class_name.blank?

        Devise.mappings.each_value do |mapping|
          return mapping.to if mapping.class_name == class_name.to_s
        end

        nil
      end
      private :masquerade_owner_class, :devise_class_for
    end
  end
end
