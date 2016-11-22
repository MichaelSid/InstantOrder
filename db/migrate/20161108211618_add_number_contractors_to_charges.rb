class AddNumberContractorsToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :number_contractors, :integer
  end
end
