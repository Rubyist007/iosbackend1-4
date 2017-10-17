class AdministationMailer < ApplicationMailer
  default from: "#{current_user.email}"

  def messaage
    mail(to: "vasargkvasargl@gmail.com", subject: "test")   
  end
end
