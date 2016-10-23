class AddLastSmsAtToContractors < ActiveRecord::Migration
  def change
    add_column :contractors, :last_sms_at, :datetime
  end
end
