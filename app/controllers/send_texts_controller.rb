class SendTextsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :admin_user, :except => :reply
  # protect_from_forgery with: :null_session,
  #     if: Proc.new { |c| c.request.format =~ %r{application/json} }

  def contractors_send
    boot_twilio
    twilio_number = Rails.application.secrets.twilio_number

    @services = ['Tech Support', 'Handyman', 'Tasks', 'Cleaning' ]

    service_type = params[:service]
    sms_body = params[:message_text]

    @contractors_list = Contractor.where(:service_type => service_type)
    

    @contractors_list.each do |maestro| 

      sms = @client.messages.create(
        from: twilio_number,
        to: maestro.mobile_number,
        body: sms_body
      )
    end
    redirect_to sms_home_path
  end

    def contractors_sms
      @services = ['Tech Support', 'Handyman', 'Tasks', 'Cleaning' ]
    end




	def send_sms(sms_body, sender_number)

		twilio_number = Rails.application.secrets.twilio_number
		# sms_body = params[:id]
		boot_twilio
		sms = @client.messages.create(
	    	from: twilio_number,
	    	to: sender_number,
	    	body: sms_body
	    )

    redirect_to show_id_path(sender_number, params[sender_number])

	end

	def sms_body

		to_number = params[:number_phone]
		message_text = params[:sms_body]
		send_sms(message_text, to_number)

	end


	def reply

	    message_body = params["Body"]
	    from_number = params["From"]
	    boot_twilio


      @sender = Contractor.find_by_mobile_number(from_number)
      if @sender == nil
        contractornew = Contractor.create(:mobile_number => from_number)
        from = from_number + " " + contractornew.id.to_s
        slack_channel = "undefined"
      else
        if @sender.first_name == nil 
          sender_first_name = ""
        else
          sender_first_name = @sender.first_name
        end
        if @sender.last_name == nil
          sender_last_name = ""
        else
          sender_last_name = @sender.last_name
        end
        if (@sender.first_name == nil) && (@sender.last_name == nil)
          sender_first_name = from_number
        end
        from = sender_first_name + " " + sender_last_name + " " +  @sender.id.to_s
        slack_channel = @sender.service_type
        if slack_channel == "Tech Support"
          slack_channel = "tech"
        elsif slack_channel == "Handyman"
          slack_channel = "handy"
        elsif slack_channel == "Tasks"
          slack_channel = "task"
        elsif slack_channel == "Cleaning"
          slack_channel = "cleaning"
        elsif slack_channel == nil
          slack_channel = "other_sms"
        end
          
      end

      
      slack_channel = "#" + slack_channel


      forward_message =  message_body

      @notifier = Slack::Notifier.new("https://hooks.slack.com/services/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", channel: slack_channel, username: from)
      @notifier.ping(forward_message)

	    # sms = @client.messages.create(
	    # # from: Rails.application.secrets.twilio_number,
	    # from: twilio_number,
	    # to: from_number,
	    # body: "Hello there, thanks for texting me. Your number is #{from_number}."
	    # )


		render 'blank-response.xml.erb', :content_type => 'text/xml'
  	end


  	def show_all

      @services = ['Tech Support', 'Handyman', 'Tasks', 'Cleaning' ]
  		boot_twilio
      twilio_number = Rails.application.secrets.twilio_number
  		@phone_number = Array.new

  		@sms_inbound = @client.messages.list(to: twilio_number).count
  		@sms_outbound = @client.messages.list(from: twilio_number).count
      @num_messages = @sms_inbound + @sms_outbound

  		@client.messages.list(to: twilio_number).each do |sms|
  			@phone_number.push(sms.from) unless @phone_number.include?(sms.from)
  		end

  		@count_from = @phone_number.count

      @totalcost = 0.00
      @cost_unit= " "
      
      @cost_unit = @client.messages.list(to: twilio_number).first.price_unit
      cost_receive = @client.messages.list(to: twilio_number).first.price.to_f
      cost_send = @client.messages.list(from: twilio_number).first.price.to_f
      @totalcost =  (@sms_inbound * cost_receive) + (@sms_outbound * cost_send)

      
  		@phone_number.each { |num|
  			unless Contractor.where(:mobile_number => num).present?
          l1 = @client.messages.list(to: twilio_number, from: num).first.date_sent.to_time
          l2 = @client.messages.list(from: twilio_number, to: num).first.date_sent.to_time
          last_date = l1
          if l2 > l1 
            last_date = l2
          end
  				contractornew = Contractor.create(:mobile_number => num, :last_sms_at => last_date)
        else
          l1 = @client.messages.list(to: twilio_number, from: num).first.date_sent.to_time
          l2 = @client.messages.list(from: twilio_number, to: num).first.date_sent.to_time
          last_date = l1
          if l2 > l1 
            last_date = l2
          end
          cc = Contractor.find_by_mobile_number(num)
          cc.last_sms_at = last_date
          cc.save
  			end
  		}


  		@contractors = Contractor.all

      @contractors.each { |num| 
        if (num.mobile_number.length > 9) && (num.mobile_number[0..2] != "+44")
          
          tmp = num.mobile_number[-10..-1]
          pre = "+44"
          updated = pre + tmp
          num.mobile_number = updated
          num.save
          # num.update_attributes(params[:mobile_number])
          # @contractors.find_by_mobile_number(num.mobile_number).save
        end      
      } 


     
      @taskers = Contractor.where(:service_type => "Tasks")
      @handy = Contractor.where(:service_type => "Handyman")
      @techies = Contractor.where(:service_type => "Tech Support")
      @cleaners = Contractor.where(:service_type => "Cleaning")
      @undefined = Contractor.where(:service_type => nil)

  	end


  	def show
  	 	boot_twilio
      twilio_number = Rails.application.secrets.twilio_number
  	 	@services = ['Tech Support', 'Handyman', 'Tasks', 'Cleaning' ]
  		@sender = params[:id]
  		@message = Array.new

  		@client.messages.list.each do |sms|
  			if sms.to == @sender || sms.from == @sender
  				@message.push(sms)
  			end
  		end

  	 	@inbound = @client.messages.list(to: twilio_number, from: @sender)
  		@outbound = @client.messages.list(from: twilio_number, to: @sender)

  		@sms_tot = @inbound.count + @outbound.count

  		@ccc = Contractor.find_by_mobile_number(@sender)
  	end


  	def new
  		@services = ['Tech Support', 'Handyman', 'Tasks', 'Cleaning' ]
  		@contractor = Contractor.new
 
  	end

  	def create
  		@services = ['Tech Support', 'Handyman', 'Tasks', 'Cleaning' ]
  		@contractor = Contractor.new

  		if @contractor.update_attributes(input_params)
    		flash[:notice] = 'The User is successfully updated!'
    		redirect_to show_id_path(@contractor.mobile_number, params[@contractor.mobile_number])
  		end
  	end


  	def update
  		@contractor = Contractor.find_by_id(params[:id])
    	

    	if @contractor.update_attributes(input_params)
    		flash[:notice] = 'The User is successfully updated!'
    		redirect_to show_id_path(@contractor.mobile_number, params[@contractor.mobile_number])
  		end

  	end


    def import_contractors
      filename_csv = params[:file].path #.original_filename
      imported_contractors = SmarterCSV.process(filename_csv)
      num_csv = imported_contractors.count
      num_csv.times do |i|
        imp_number = imported_contractors[i][:mobile_number].to_s

        if (imp_number.length > 9) && (imp_number[0..2] != "+44")
          
          tmp = imp_number[-10..-1]
          pre = "+44"
          updated = pre + tmp
          imp_number = updated
          # num.update_attributes(params[:mobile_number])
          # @contractors.find_by_mobile_number(num.mobile_number).save
        end      

        unless Contractor.where(:mobile_number => imp_number).present?
          Contractor.create(imported_contractors[i])
        end
      end

      redirect_to sms_home_path

    end

    def import_csv
    end

  
  




	private
 
	def boot_twilio
	   account_sid = Rails.application.secrets.twilio_sid
	   auth_token = Rails.application.secrets.twilio_token
		  @client = Twilio::REST::Client.new account_sid, auth_token
	end


	def input_params
		params.require(:contractor).permit(:mobile_number, :first_name, :last_name, 
			:company_name, :service_type, :nunmber_jobs_done, :gross_paid, 
			:materials_refund, :net_pay, :last_job_at, :rating, :description, 
			:first_job_at, :mobile_number, :signed_contract)
    end

 def admin_user
      redirect_to(root_url) unless current_user && current_user.admin?
end


end
