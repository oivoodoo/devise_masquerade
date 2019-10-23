require 'devise'
require 'devise_masquerade/version'
require 'devise_masquerade/routes'
require 'devise_masquerade/controllers/helpers'
require 'devise_masquerade/controllers/url_helpers'
require 'devise_masquerade/rails'

module Devise
  mattr_accessor :masquerade_param
  @@masquerade_param = 'masquerade'

  mattr_accessor :masquerade_expires_in
  @@masquerade_expires_in = 1.minute

  mattr_accessor :masquerade_key_size
  @@masquerade_key_size = 16

  mattr_accessor :masquerade_bypass_warden_callback
  @@masquerade_bypass_warden_callback = false

  mattr_accessor :masquerade_routes_back
  @@masquerade_routes_back = false

  # Example: Devise.masqueraded_resource_class = User
  mattr_accessor :masqueraded_resource_class

  # Example: Devise.masqueraded_resource_name = :user
  mattr_accessor :masqueraded_resource_name

  # Example: Devise.masquerading_resource_class = AdminUser
  mattr_accessor :masquerading_resource_class

  # Example: Devise.masquerading_resource_name = :admin_user
  mattr_accessor :masquerading_resource_name

  @@helpers << DeviseMasquerade::Controllers::Helpers
end

Devise.add_module :masqueradable, controller: :masquerades,
  model: 'devise_masquerade/models', route: :masquerade
