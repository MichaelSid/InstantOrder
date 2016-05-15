class RemoveNameFieldsFromAccount < ActiveRecord::Migration
  def up
    remove_column :accounts, :first_name
    remove_column :accounts, :last_name
  end

  def down
    add_column :accounts, :first_name, :string
    add_column :accounts, :last_name, :string
  end
end
