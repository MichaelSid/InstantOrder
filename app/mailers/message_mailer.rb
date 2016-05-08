class MessageMailer < ActionMailer::Base
  default from: "noreply@instela.co"

  def new_message(message)
    @message = message
    
    mail to: 'hello@instela.co', subject: "Message from #{message.name}"
  end


end
