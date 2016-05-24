class ChargesController < ApplicationController

	load_and_authorize_resource

	def new
		@charge = Charge.new
		puts 'hello!'
    # this will remain empty unless you need to set some instance variables to pass on
  end
 
  def create
  	begin
  		@charge = Charge.new
			@customer = Account.find_by_email(params[:company_email]).stripe_id
	  	@charge.amount = params[:duration].to_d * determine_hourly_fee(params[:service_type]).to_d
	  	charge = Stripe::Charge.create(
		    amount: (@charge.amount * 100).to_i,
		    currency: 'gbp',
		    customer: @customer
			)
			if (charge && @charge.save)
				ChargesMailer.send_receipt(params, @charge).deliver 
			end
			flash[:alert] = 'Successful Charge!'
			return redirect_to root_path
		rescue Stripe::CardError => e
			logger.error(e.message)
			flash.now[:alert] = 'Charge failed!'
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
  	else
  		return 15
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
