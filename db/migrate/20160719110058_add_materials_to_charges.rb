class AddMaterialsToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :materials_total_cost, :decimal
  end
end
