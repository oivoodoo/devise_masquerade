module Devise
  module Models
    module Masqueradable
      extend ActiveSupport::Concern

      included do
        attr_reader :masquerade_key

        def masquerade!
          @masquerade_key = SecureRandom.base64(Devise.masquerade_key_size)

          Rails.cache.write("#{self.class.name.pluralize.downcase}:#{@masquerade_key}:masquerade", id, :expires_in => Devise.masquerade_expires_in)
        end

        def self.find_by_masquerade_key(key)
          id = Rails.cache.read("#{self.name.pluralize.downcase}:#{key}:masquerade")

          # clean up the cached masquerade key value
          Rails.cache.write("#{self.name.pluralize.downcase}:#{key}:masquerade", nil)

          self.find_by_id(id)
        end
      end
    end
  end
end

