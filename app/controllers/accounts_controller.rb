class AccountsController < ApplicationController

	def new
		prepare_meta_tags title: "New Instela Account", description: "Sign Up With Instela for On-Demand Office Support!"
		@account = Account.new
	end

	def create
		logger.debug(params)
		
		
		@account = Account.new(account_params)
		if @account.save
			flash[:message] = 'Thank you for signing up! We will be in touch.'
		else
			flash[:error] = 'You need to fill in all the fields.'
			return render 'new'	
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

	# def add_card_details
	# 	@account_id = params[:account_id]
	# 	render 'add_card_details'
	# end

	# def save_card_details
	# 	@account = Account.find(params[:account_id])
	# 	# get the credit card details submitted by the form or app
 #    if @account.update_attributes(account_params)
	# 		token = params[:stripeToken]
	# 		# create a Customer
	# 		customer = Stripe::Customer.create(
	# 		  card: token,
	# 		  description: 'New Customer',
	# 		  email: params[:stripeEmail]
	# 		)
	# 		@account.stripe_id = customer.id
	# 		@account.save
	# 	end
	# end



	private

	def account_params
		params.require(:account).permit(:account, :email, :first_name, :last_name, :company, :mobile_phone)
	end


end
