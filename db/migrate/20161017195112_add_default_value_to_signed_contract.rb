class AddDefaultValueToSignedContract < ActiveRecord::Migration
  def change
  	change_column :contractors, :signed_contract?, :boolean, :default => false, :null => false
  end
end
