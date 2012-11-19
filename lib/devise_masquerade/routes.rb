module ActionDispatch::Routing
  class Mapper

    protected

    def devise_masquerade(mapping, controllers)
      resources :masquerade, :only => :show,
        :path => mapping.path_names[:masquerade],
        :controller => controllers[:masquerades] do
      end
    end
  end
end

