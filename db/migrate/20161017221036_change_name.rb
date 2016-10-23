class ChangeName < ActiveRecord::Migration
  def change
  	  	rename_column :contractors, :signed_contract?, :signed_contract
  end
end
