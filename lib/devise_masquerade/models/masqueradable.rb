module DeviseMasquerade
  module Models
    module Masqueradable
      extend ActiveSupport::Concern

      included do
        def masquerade_key
          to_sgid(expires_in: Devise.masquerade_expires_in, for: 'masquerade')
        end
      end
    end
  end
end
