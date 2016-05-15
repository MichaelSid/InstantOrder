class RemoveEmailFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :email
  end

  def down
    add_column :accounts, :email, :string
  end
end
