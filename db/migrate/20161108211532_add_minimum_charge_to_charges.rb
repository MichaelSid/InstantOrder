class AddMinimumChargeToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :minimum_charge, :decimal
  end
end
