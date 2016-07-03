class AddAddressToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :address, :text
  end
end
