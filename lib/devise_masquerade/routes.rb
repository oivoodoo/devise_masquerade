module DeviseMasquerade
  module Routes

    def devise_masquerade(mapping, controllers)
      resources :masquerade,
        only: :show,
        path: mapping.path_names[:masquerade],
        controller: controllers[:masquerades] do

        collection do
          get :back
        end
      end
    end

  end
end

ActionDispatch::Routing::Mapper.send :include, DeviseMasquerade::Routes
