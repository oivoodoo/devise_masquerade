require 'securerandom'

module DeviseMasquerade
  module Controllers

    module UrlHelpers
      def masquerade_path(resource, *args)
        scope = Devise::Mapping.find_scope!(resource)

        opts = args.shift || {}
        opts.merge!(masqueraded_resource_class: resource.class.name)

        opts.merge!(Devise.masquerade_param => resource.masquerade_key)

        send("#{scope}_masquerade_index_path", opts, *args)
      end

      def back_masquerade_path(resource, *args)
        scope = Devise::Mapping.find_scope!(resource)

        opts = args.first || {}
        opts.merge!(masqueraded_resource_class: resource.class.name)

        send("back_#{scope}_masquerade_index_path", opts, *args)
      end
    end

  end
end

