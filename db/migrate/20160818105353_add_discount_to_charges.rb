class AddDiscountToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :discount, :decimal
  end
end
