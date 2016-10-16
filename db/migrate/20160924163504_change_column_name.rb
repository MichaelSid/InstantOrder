class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :contractors, :nunmber_jods_done, :nunmber_jobs_done
  end
end
