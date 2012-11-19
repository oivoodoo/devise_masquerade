require 'devise'

require 'action_controller'
require 'action_controller/base'
require 'devise_masquerade/version'
require 'devise_masquerade/routes'
require 'devise_masquerade/controllers/helpers'
require 'devise_masquerade/controllers/url_helpers'
require 'devise_masquerade/rails'

module DeviseMasquerade
end

module Devise
  @@helpers << DeviseMasquerade::Controllers::Helpers
end

Devise.add_module :masqueradable, :controller => :masquerades, :model => 'devise_masquerade/model', :route => :masquerade

