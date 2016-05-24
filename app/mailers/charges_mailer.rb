class ChargesMailer < ActionMailer::Base
  default from: "noreply@instela.co"

  def send_receipt(params, charge)
    @company_email = params[:company_email]
    @amount = charge.amount
    @duration = params[:duration]
    mail to: @company_email, subject: "Receipt for order #{charge.id}"
  end


end
