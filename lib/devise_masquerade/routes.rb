module DeviseMasquerade
  module Routes

    def devise_masquerade(mapping, controllers)
      resources :masquerade,
        path: mapping.path_names[:masquerade],
        controller: controllers[:masquerades],
        only: [] do

        collection do
          get :show
          get :back
        end
      end
    end

  end
end

ActionDispatch::Routing::Mapper.send :include, DeviseMasquerade::Routes
