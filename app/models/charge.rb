class Charge < ActiveRecord::Base
  belongs_to :account
  has_one :order
  has_one :contractors
end
