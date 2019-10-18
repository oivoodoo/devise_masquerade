require 'devise_masquerade/routes'
require 'devise_masquerade/models'

module DeviseMasquerade
  module Rails

    class Engine < ::Rails::Engine
      ActiveSupport.on_load(:action_controller) do
        include DeviseMasquerade::Controllers::Helpers
        include DeviseMasquerade::Controllers::UrlHelpers
      end

      ActiveSupport.on_load(:action_view) do
        include DeviseMasquerade::Controllers::UrlHelpers
      end
    end

  end
end
