class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


	validates_presence_of :mobile_phone, :full_name, :company, :email, :address_l1, :postcode

	has_many :charges
	has_many :orders
end
