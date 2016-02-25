class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :mobile_phone

      t.timestamps
    end
  end
end
