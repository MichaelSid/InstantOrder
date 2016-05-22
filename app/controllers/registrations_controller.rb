class RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters


	def new
		prepare_meta_tags title: "New Instela Account", description: "Sign Up With Instela for On-Demand Office Support!"
		super
	end



	def create
		resource = build_resource(sign_up_params)
		token = params['payment_token']
		# create a Stripe Customer
		if token.present?
			customer = Stripe::Customer.create(
			  card: token,
			  description: 'New Customer',
			  email: params[:email]
			)
			resource.stripe_id = customer.id
		else
			flash[:error] = 'There was a problem registering your card details.'
			return render 'new'
		end
		if resource.save
			flash[:success] = 'Thank you for signing up! We will be in touch.'
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


	def update
		if params[:payment_token].present?
			# replace the Customer
			puts 'present!!!'
			customer = Stripe::Customer.create(
			  card: params[:payment_token],
			  description: 'Edit Customer',
			  email: params[:account][:email]
			)
			resource.stripe_id = customer.id
			resource.save
		end
		super
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


	protected


  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def configure_permitted_parameters
  	devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :mobile_phone, :company, :payment_token])
  end

  private

  def account_update_params
    params.require(:account).permit(:full_name, :email, :password, :password_confirmation, :mobile_phone, :company, :payment_token)
  end
end
