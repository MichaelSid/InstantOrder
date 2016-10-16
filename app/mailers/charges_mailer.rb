class ChargesMailer < ActionMailer::Base
  default from: "receipts@instela.co", return_path: 'help@instela.co'





  def send_receipt(charge)
    @charge = charge
    @order = charge
  
  	attachments["instela-invoice-##{charge.id}.pdf"] = WickedPdf.new.pdf_from_string(
    render_to_string(:pdf => "invoice",:template => 'orders/show.pdf.erb', :page_size  => "Letter",
  :dpi => '300')
  	)
  	self.instance_variable_set(:@lookup_context, nil)
  	mail :subject => "Your invoice from instela", :to => @charge.account.email, bcc: ["help@instela.co"]




  #   attachments["invoice.pdf"] = WickedPdf.new.pdf_from_string(
  #   	render_to_string(:pdf => "invoice",:template => 'orders/show.pdf.erb'))
  # self.instance_variable_set(:@lookup_context, nil)

    # mail to: @charge.account.email, subject: "Receipt for Order ##{charge.id}",  bcc: ["help@instela.co"]
  end



end
