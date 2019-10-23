module DeviseMasquerade
  module Models
    module Masqueradable
      extend ActiveSupport::Concern

      included do
        attr_reader :masquerade_key

        def masquerade!
          @masquerade_key = SecureRandom.urlsafe_base64(
            Devise.masquerade_key_size)
          cache_key = self.class.cache_masquerade_key_by(@masquerade_key)
          ::Rails.cache.write(
            cache_key, id, expires_in: Devise.masquerade_expires_in)
        end
      end

      module ClassMethods
        def cache_masquerade_key_by(key)
          "#{self.name.pluralize.underscore}:#{key}:masquerade"
        end

        def remove_masquerade_key!(key)
          ::Rails.cache.delete(cache_masquerade_key_by(key))
        end

        def find_by_masquerade_key(key)
          id = ::Rails.cache.read(cache_masquerade_key_by(key))

          # clean up the cached masquerade key value
          remove_masquerade_key!(key)

          where(id: id)
        end

        def find_by_masquerade_key(key)
          id = ::Rails.cache.read(cache_masquerade_key_by(key))

          # clean up the cached masquerade key value
          remove_masquerade_key!(key)

          where(id: id)
        end
      end # ClassMethods
    end
  end
end
