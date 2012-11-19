module DeviseMasquerade
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) { include DeviseMasquerade::Controllers::UrlHelpers }
    ActiveSupport.on_load(:action_view)       { include DeviseMasquerade::Controllers::UrlHelpers }
  end
end

