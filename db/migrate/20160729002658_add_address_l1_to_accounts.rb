class AddAddressL1ToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :address_l1, :text
  end
end
