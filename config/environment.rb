# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: 'app80912783@heroku.com',
  password: 'lb6kvdjl6743',
  domain: 'https://iosbackend1-4.herokuapp.com/',
  address: 'smtp.sendgrid.net',
  port: '587',
  authentication: :plain,
  enable_strattls_auto: true
}
