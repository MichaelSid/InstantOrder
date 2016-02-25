class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :details
      t.belongs_to :account, index: true

      t.timestamps
    end
  end
end
