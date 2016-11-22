class ChargesController < ApplicationController

	load_and_authorize_resource

	def new
		@charge = Charge.new
		@services = ['Tech Support', 'Handyman', 'Tasks', 'Cleaning' ]
		@accounts = Account.all.map{ |u| "#{u.full_name},  #{u.email},   (#{u.stripe_id})" }
		@contractors = Contractor.all.map{ |c|  "#{c.service_type},  #{c.first_name}, #{c.mobile_number}, #{c.id}"}

    # this will remain empty unless you need to set some instance variables to pass on
  end
 
  def create
  	begin
  		email = params[:company_email].split(/\,/).map(&:strip)[1] # 0 is full name, 1 is email and 2 is stripe id
  		mob = params[:contractor_mobile].split(/\,/).map(&:strip)[2] # 0 is service type, 1 first name, 2 mobile
  		job_date = params[:date_job].to_s

  		account = Account.find_by_email(email)
  		@job_contractor = Contractor.find_by_mobile_number(mob)
			stripe_id = account.stripe_id
  		@charge = account.charges.new
			@charge.service_type = params[:service_type]
			@charge.duration = params[:duration].to_d
			@charge.hourly_fee = determine_hourly_fee(@charge.service_type).to_d
			@charge.materials_total_cost = params[:materials_total_cost]		
			@charge.quote_fee = params[:quote_fee].to_d
			@charge.minimum_charge = params[:minimum_charge].to_d
			@charge.number_contractors = params[:number_contractors].to_i

			@charge.discount = params[:discount]

			charge_hour_pay = (@charge.duration * @charge.hourly_fee)
			if @charge.minimum_charge > 0
				tmp_duration = @charge.duration - 1
				charge_hour_pay = tmp_duration*@charge.hourly_fee + @charge.minimum_charge
			end
			if @charge.number_contractors > 1
				charge_hour_pay = charge_hour_pay * @charge.number_contractors 
			end
			charge_hour_pay = charge_hour_pay * ((100-@charge.discount)/100)

	  		@charge.amount = charge_hour_pay + @charge.materials_total_cost + @charge.quote_fee
	  	




	  	if @job_contractor.nunmber_jobs_done.nil?
	  		@job_contractor.nunmber_jobs_done = 0 
	  	end

	  	if @job_contractor.nunmber_jobs_done == 0
	  		@job_contractor.first_job_at = Date.parse(job_date) 
	  	end
	  	if @job_contractor.net_pay.nil?
	  		@job_contractor.net_pay = 0
	  	end
	  	if @job_contractor.gross_paid.nil?
	  		@job_contractor.gross_paid = 0
	  	end
	  	if @job_contractor.materials_refund.nil?
	  		@job_contractor.materials_refund = 0
	  	end

	  	pay_rate = determine_hourly_pay(@charge.service_type).to_d
	  	pay_job  = pay_rate * @charge.duration
	  	@job_contractor.nunmber_jobs_done = @job_contractor.nunmber_jobs_done + 1
	  	@job_contractor.last_job_at = Date.parse(job_date) 
	  	@job_contractor.net_pay = @job_contractor.net_pay + pay_job
	  	@job_contractor.gross_paid = @job_contractor.gross_paid + pay_job + params[:materials_refund].to_d
	  	@job_contractor.materials_refund = @job_contractor.materials_refund + params[:materials_refund].to_d
	  	@job_contractor.save



	  	charge = Stripe::Charge.create(
		    amount: (@charge.amount * 100).to_i,
		    currency: 'gbp',
		    description: 'New Charge',
		    customer: stripe_id
			)
			if (charge && @charge.save)
				ChargesMailer.send_receipt(@charge).deliver 
				ChargesMailer.send_rating(@charge).deliver 
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
  		return 55
  	elsif service_type == 'Tasks'
  		return 25
  	elsif service_type == 'Cleaning'
  		return 15
  	else
  		raise 'Cannot recognise service type!'
  	end
  end


  def determine_hourly_pay(service_type)
  	if service_type == 'Tech Support'
  		return 55
  	elsif service_type == 'Handyman'
  		return 40
  	elsif service_type == 'Tasks'
  		return 15
  	elsif service_type == 'Cleaning'
  		return 12
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
