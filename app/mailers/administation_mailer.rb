class AdministationMailer < ApplicationMailer
  default from: "sandbox46b5b95dac97447ca3b162b57a058f6d.mailgun.org"

  def messaage
    mail(to: "vasargkvasargl@gmail.com", subject: "test")   
  end
end
