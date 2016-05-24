class AddAdminToAccount < ActiveRecord::Migration
  def change
  	add_column :accounts, :admin?, :boolean, default: false
  end
end
