class AccountsController < ApplicationController

	def create
		logger.debug(params)
		# get the credit card details submitted by the form or app
		token = params[:stripeToken]

		# create a Customer
		customer = Stripe::Customer.create(
		  card: token,
		  description: 'New Customer',
		  email: params[:stripeEmail]
		)

		account = Account.new
		account.email = params[:stripeEmail]
		account.stripe_id = customer.id
		account.mobile_phone =  params[:mobile_phone]
		account.save
		

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

end
