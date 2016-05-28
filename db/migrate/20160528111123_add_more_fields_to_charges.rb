class AddMoreFieldsToCharges < ActiveRecord::Migration
  def change
  	add_column :charges, :service_type, :string
  	add_column :charges, :duration, :decimal
  	add_column :charges, :hourly_fee, :decimal
  	add_reference :charges, :account, index: true
  end
end
