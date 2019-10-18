require 'devise_masquerade/models/masqueradable'

module DeviseMasquerade
  module Models

  end
end

Devise::Models.send :include, DeviseMasquerade::Models
