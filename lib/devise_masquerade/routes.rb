module ActionDispatch::Routing
  class Mapper
    protected

    def devise_masquerade(mapping, controllers)
      resource :masquerade, :only => [],
        :path => mapping.path_names[:masquerade],
        :controller => controllers[:masquerades] do

        get :masquerade, :path => mapping.path_names[:accept], :as => :accept
      end
    end
  end
end

