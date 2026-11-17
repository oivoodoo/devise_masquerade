require 'securerandom'

module DeviseMasquerade
  module Controllers

    module UrlHelpers
      def masquerade_path(resource, *args)
        scope = Devise::Mapping.find_scope!(resource)

        opts = args.shift || {}
        opts[:masqueraded_resource_class] = resource.class.name

        opts[Devise.masquerade_param] = resource.masquerade_key

        masquerade_route_helper("#{scope}_masquerade_index_path", opts, *args)
      end

      def back_masquerade_path(resource, *args)
        scope = Devise::Mapping.find_scope!(resource)

        opts = args.first || {}
        opts[:masqueraded_resource_class] = resource.class.name

        masquerade_route_helper("back_#{scope}_masquerade_index_path", opts, *args)
      end

      private

      # Inside a mounted engine the route helpers are the engine's, not the
      # host app's where the masquerade routes live. Fall back to main_app.
      def masquerade_route_helper(name, *args)
        if !respond_to?(name, true) && respond_to?(:main_app)
          main_app.public_send(name, *args)
        else
          send(name, *args)
        end
      end
    end

  end
end

