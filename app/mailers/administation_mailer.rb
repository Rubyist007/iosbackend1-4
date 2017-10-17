class AdministationMailer < ApplicationMailer

  def messaage subject, text
    mail to: "vasargkvasargl@gmail.com", subject: "#{subject}", text: "#{text}"
  end
end
