module DeviseMasquerade
  module Controllers
    module UrlHelpers
      def masquerade_path(resource)
        scope = Devise::Mapping.find_scope!(resource)
        send("#{scope}_masquerade_path", resource)
      end
    end
  end
end

