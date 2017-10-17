class ApplicationMailer < ActionMailer::Base
  require 'mailgun'

  default from: 'administration-R8@example.com'
  layout 'mailer'


end
