class ChargesMailer < ActionMailer::Base
  default from: "receipts@instela.co"

  def send_receipt(charge)
    @charge = charge
    mail to: @charge.account.email, subject: "Receipt for Order ##{charge.id}"
  end


end
