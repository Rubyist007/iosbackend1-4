class ReportMailer < ApplicationMailer
  default from: "test@R8.com"

  def report subject, text, user
    mail from: "#{user.email}", to: "sg.maximO1@gmail.com", subject: "#{subject}", text: "#{text}"
  end
end
