class Account < ActiveRecord::Base
	validates_presence_of :mobile_phone, :first_name, :last_name, :company
end
