class CreateContractors < ActiveRecord::Migration
  def change
    create_table :contractors do |t|
      t.string :first_name
      t.string :last_name
      t.string :service_type
      t.integer :nunmber_jods_done
      t.float :gross_paid
      t.float :materials_refund
      t.float :net_pay
      t.datetime :last_job_at
      t.float :rating
      t.string :company_name
      t.text :description
      t.datetime :first_job_at
      t.boolean :signed_contract
      t.string :mobile_number

      t.timestamps
    end
  end
end
