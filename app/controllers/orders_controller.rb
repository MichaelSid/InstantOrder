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
	end

end