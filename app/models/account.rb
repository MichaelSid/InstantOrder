class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  attr_accessor :password, :password_confirmation       
	validates_presence_of :mobile_phone, :full_name, :company, :email
end
