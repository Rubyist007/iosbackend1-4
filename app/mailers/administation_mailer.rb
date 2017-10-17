class AdministationMailer < ApplicationMailer
  default from: "test@R8.com"

  def messaage
    mail from: "test@R8.com", to: "vasargkvasargl@gmail.com", subject: "test" 
    #render json: 'Done'
  end
end
