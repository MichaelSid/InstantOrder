class MessageMailer < ActionMailer::Base
  default from: "noreply@instela.co"

  def new_message(message)
    @message = message
    
    mail subject: "Message from #{message.name}"
  end


end
