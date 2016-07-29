class AddAddressL2ToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :address_l2, :text
  end
end
