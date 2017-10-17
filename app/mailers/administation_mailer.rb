class AdministationMailer < ApplicationMailer
  default from: "test@R8.com"

  def messaage
    mail(to: "vasargkvasargl@gmail.com", subject: "test")   
  end
end
