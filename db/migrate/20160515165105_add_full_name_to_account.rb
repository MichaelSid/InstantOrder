class AddFullNameToAccount < ActiveRecord::Migration
  def change
  	add_column :accounts, :full_name, :string
  end
end
