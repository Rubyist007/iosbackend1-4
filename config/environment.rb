# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: 'app79208398@heroku.com',
  password: '0k55kxxy1296',
  domain: 'https://iosbackend-test.herokuapp.com/',
  address: 'smtp.sendgrid.net',
  port: '587',
  authentication: :plain,
  enable_strattls_auto: true
}
