# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: 'app79141217@heroku.com',
  password: 'c56k5hyy7989',
  domain: 'https://iosbackend-test.herokuapp.com/',
  address: 'smtp.sendgrid.net',
  port: '587',
  authentication: :starter,
  enable_strattls_auto: true
}
