# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: 'app80146760@heroku.com',
  password: '0r4rwskl7153',
  domain: 'https://iosbackend1-4.herokuapp.com/',
  address: 'smtp.sendgrid.net',
  port: '587',
  authentication: :plain,
  enable_strattls_auto: true
}
