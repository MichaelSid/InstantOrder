class ChargesMailer < ActionMailer::Base
  default from: "receipts@instela.co", return_path: 'help@instela.co'

  def send_receipt(charge)
    @charge = charge
    mail to: @charge.account.email, subject: "Receipt for Order ##{charge.id}",  bcc: ["help@instela.co"]
  end


end
