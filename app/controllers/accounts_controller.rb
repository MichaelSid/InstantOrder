class AccountsController < ApplicationController

	def new
		@account = Account.new
	end

	def create
		logger.debug(params)
		# get the credit card details submitted by the form or app
		token = params[:stripeToken]
		
		@account = Account.new(account_params)
		if @account.save
			# create a Customer
			customer = Stripe::Customer.create(
			  card: token,
			  description: 'New Customer',
			  email: params[:stripeEmail]
			)
			@account.stripe_id = customer.id
			@account.email = customer.email
		else
			flash[:alert] = 'Error'
			return redirect_to :back		
		end

		redirect_to root_path
			# charge the Customer instead of the card
			# Stripe::Charge.create(
			#     amount: 1080, # in cents
			#     currency: 'usd',
			#     customer: customer.id
			# )

			# # save the customer ID in your database so you can use it later
			# save_stripe_customer_id(user, customer.id)

			# # later
			# customer_id = get_stripe_customer_id(user)

			# Stripe::Charge.create(
			#     amount: 1500, # $15.00 this time
			#     currency: 'usd',
			#     customer: customer_id
			# )
	end

	private

	def account_params
		params.require(:account).permit(:account, :email, :first_name, :last_name, :company, :mobile_phone)
	end


end
