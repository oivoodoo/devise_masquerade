require 'spec_helper'

module EngineUrlHelpersSpec
  class Engine < ::Rails::Engine
    isolate_namespace EngineUrlHelpersSpec
  end

  class PagesController < ActionController::Base
    def show
      render inline: '<%= raw masquerade_path(User.first) %>|<%= raw back_masquerade_path(User.first) %>'
    end
  end
end

EngineUrlHelpersSpec::Engine.routes.draw { get '/page', to: 'pages#show' }

describe EngineUrlHelpersSpec::PagesController, type: :controller do
  routes { EngineUrlHelpersSpec::Engine.routes }
  render_views

  let!(:user) { create(:user) }

  it 'builds masquerade paths from inside a mounted engine' do
    get :show

    masquerade, back = response.body.split('|')
    routes = Rails.application.routes.url_helpers

    # The masquerade key is signed with an expiry, so compare the path and params, not the token.
    uri = URI.parse(masquerade)
    params = Rack::Utils.parse_query(uri.query)
    expect(uri.path).to eq(routes.user_masquerade_index_path)
    expect(params['masquerade']).to be_present
    expect(params['masqueraded_resource_class']).to eq('User')

    expect(back).to eq(routes.back_user_masquerade_index_path(masqueraded_resource_class: 'User'))
  end
end
