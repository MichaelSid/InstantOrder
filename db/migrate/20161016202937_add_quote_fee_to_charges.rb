class AddQuoteFeeToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :quote_fee, :decimal
  end
end
