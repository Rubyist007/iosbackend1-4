Devise.setup do |config|
  config.mailer_sender = "R8.suport@heroku.com"
  config.password_length = 7..128
  config.mailer = "DeviseSidekiq"
end
