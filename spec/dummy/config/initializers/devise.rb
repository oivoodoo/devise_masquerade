Devise.setup do |config|
  config.mailer_sender = "support@example.com"

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end

