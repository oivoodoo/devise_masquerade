module ActionDispatch::Routing
  class Mapper

    protected

    def devise_masquerade(mapping, controllers)
      resources :masquerade,
        :only => :show,
        :path => mapping.path_names[:masquerade],
        :controller => controllers[:masquerades] do

        get :back, :on => :collection
      end
    end
  end
end

