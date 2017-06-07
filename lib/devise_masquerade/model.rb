module Devise
  module Models
    module Masqueradable
      def self.included(base)
        base.class_eval do
          attr_reader :masquerade_key

          include InstanceMethods
          extend ClassMethods
        end
      end

      module InstanceMethods
        def masquerade!
          @masquerade_key = SecureRandom.urlsafe_base64(Devise.masquerade_key_size)
          Rails.cache.write("#{self.class.name.pluralize.underscore}:#{@masquerade_key}:masquerade", id, :expires_in => Devise.masquerade_expires_in)
        end
      end

      module ClassMethods
        def cache_masquerade_key_by(key)
          "#{self.name.pluralize.underscore}:#{key}:masquerade"
        end

        def remove_masquerade_key!(key)
          Rails.cache.delete(cache_masquerade_key_by(key))
        end

        def find_by_masquerade_key(key)
          id = Rails.cache.read(cache_masquerade_key_by(key))

          # clean up the cached masquerade key value
          remove_masquerade_key!(key)

          where(id: id).first
        end
      end # ClassMethods
    end
  end
end

