class AdministationMailer < ApplicationMailer
  default from: "test@R8.com"

  def messaage
 #   mg_client = Mailgun::Client.new 'key-cf696ec28d426e53abaf0a3653ce7dea' 

 #   message_params = {from: 'testuset@gmail.com',
 #               to: 'vasargkvasargl@gmail.com',
 #               subject: 'etst',
 #               text: 'test'}

#    mg_client.send_message 'sandbox6c8063d955234a3a8d59ebe240367df1.mailgun.org', message_params
    mail from: "test@R8.com", to: "vasargkvasargl@gmail.com", subject: "test", text: 'Done?' 
    #render json: 'Done'
  end
end
