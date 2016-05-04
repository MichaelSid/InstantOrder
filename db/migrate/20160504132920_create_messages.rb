class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :name
      t.string :email
      t.string :company
      t.text :content
      t.string :mobile

      t.timestamps
    end
  end
end
