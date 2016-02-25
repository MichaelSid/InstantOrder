class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.float :amount
      t.belongs_to :order, index: true

      t.timestamps
    end
  end
end
