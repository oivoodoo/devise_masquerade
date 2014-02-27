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
  mattr_accessor :masquerade_param
  @@masquerade_param = 'masquerade'

  mattr_accessor :masquerade_expires_in
  @@masquerade_expires_in = 10.seconds

  mattr_accessor :masquerade_key_size
  @@masquerade_key_size = 16

  mattr_accessor :masquerade_bypass_warden_callback
  @@masquerade_bypass_warden_callback = false

  @@helpers << DeviseMasquerade::Controllers::Helpers
end

Devise.add_module :masqueradable, :controller => :masquerades, :model => 'devise_masquerade/model', :route => :masquerade

