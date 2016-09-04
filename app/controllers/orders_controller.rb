class OrdersController < ApplicationController

  # def new
  # end
 


	def history
		account = Account.find_by_id(current_account.id) # find_by_email(current_accounts.email)
  		@orders = account.charges.all 
  	end

  	def show
  		@account = Account.find_by_id(current_account.id)
  		@order = @account.charges.find_by_id(params[:id])


    

      respond_to do |format|
        format.html
      format.pdf do
        @pdf = render_to_string pdf: "instela-invoice-##{@order.id}",
               template: "orders/show.pdf.erb",
               :page_height => '9.05in', :page_width => '6in',
               locals: {:order => @order}
        send_data(@pdf, :filename => "instela-invoice-##{@order.id}",  :type=>"application/pdf")

        end
      end

	end

end