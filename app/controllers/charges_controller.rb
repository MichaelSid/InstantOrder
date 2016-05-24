class ChargesController < ApplicationController

	load_and_authorize_resource

	def new
		puts 'hello!'
    # this will remain empty unless you need to set some instance variables to pass on
  end
 
  def create
  	Stripe::Charge.create(
	    amount: params[:amount]
	    currency: 'gbp',
	    customer: account.stripe_id
		)
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
end
