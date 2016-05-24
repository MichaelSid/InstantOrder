class Order < ActiveRecord::Base
  belongs_to :account
  has_one :charge
end
