# frozen_string_literal: true

module DeviseMasquerade
  module Rails

    class Engine < ::Rails::Engine
      initializer "devise.url_helpers" do
        Devise.include_helpers(DeviseMasquerade::Controllers)
      end

      ActiveSupport.on_load(:action_controller) do
        include DeviseMasquerade::Controllers::Helpers
      end
    end

  end
end
