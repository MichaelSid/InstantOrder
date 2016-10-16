class RenamesContractor < ActiveRecord::Migration
  def change
  	rename_table :contractor, :contractors
  end
end

