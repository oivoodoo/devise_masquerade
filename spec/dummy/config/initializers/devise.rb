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
  config.secret_key = 'a4d9ea637f061521f68da64f5f66bd01746ea66a93f284725ad13ff6b27a1dac4ffde6503259f9445299bf855abaa56054f6d1fec5a09346e7220ee777236bb8'
end

