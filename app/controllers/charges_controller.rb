class ChargesController < ApplicationController

	load_and_authorize_resource

	def new
		@charge = Charge.new
		@services = ['Tech Support', 'Handyman', 'Tasks', 'Cleaning' ]
		@accounts = Account.all.map{ |u| u.email }
    # this will remain empty unless you need to set some instance variables to pass on
  end
 
  def create
  	begin
  		account = Account.find_by_email(params[:company_email])
			stripe_id = account.stripe_id
  		@charge = account.charges.new
			@charge.service_type = params[:service_type]
			@charge.duration = params[:duration].to_d
			@charge.hourly_fee = determine_hourly_fee(@charge.service_type).to_d
			@charge.materials_total_cost = params[:materials_total_cost]
	  	@charge.amount = (@charge.duration * @charge.hourly_fee) + @charge.materials_total_cost
	  	charge = Stripe::Charge.create(
		    amount: (@charge.amount * 100).to_i,
		    currency: 'gbp',
		    description: 'New Charge',
		    customer: stripe_id
			)
			if (charge && @charge.save)
				ChargesMailer.send_receipt(@charge).deliver 
			end
			flash[:alert] = 'Successful Charge!'
			return redirect_to root_path
		rescue Stripe::CardError => e
			logger.error(e.message)
			flash.now[:error] = e.message
			return render 'new'
		end 
  end

  def determine_hourly_fee(service_type)
  	if service_type == 'Tech Support'
  		return 70
  	elsif service_type == 'Handyman'
  		return 50
  	elsif service_type == 'Tasks'
  		return 20
  	elsif service_type == 'Cleaning'
  		return 15
  	else
  		raise 'Cannot recognise service type!'
  	end
  end


      # Amount in cents
	#   @amount = 500

	#   customer = Stripe::Customer.create(
	#     :email => params[:stripeEmail],
	#     :source  => params[:stripeToken]
	#   )

	#   charge = Stripe::Charge.create(
	#     :customer    => customer.id,
	#     :amount      => @amount,
	#     :description => 'Rails Stripe customer',
	#     :currency    => 'usd'
	#   )

	# rescue Stripe::CardError => e
	#   flash[:error] = e.message
	#   redirect_to new_charge_path

end
