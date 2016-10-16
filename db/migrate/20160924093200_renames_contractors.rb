class RenamesContractors < ActiveRecord::Migration
  def change
  	rename_table :contractors, :contractor
  end
end
