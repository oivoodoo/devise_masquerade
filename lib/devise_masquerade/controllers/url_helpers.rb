module DeviseMasquerade
  module Controllers
    module UrlHelpers
      def masquerade_path(resource)
        scope = Devise::Mapping.find_scope!(resource)
        send("#{scope}_masquerade_path", resource)
      end

      def back_masquerade_path(resource)
        scope = Devise::Mapping.find_scope!(resource)
        send("back_#{scope}_masquerade_index_path")
      end
    end
  end
end

