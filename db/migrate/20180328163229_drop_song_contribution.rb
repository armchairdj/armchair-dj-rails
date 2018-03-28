class DropWorkContribution < ActiveRecord::Migration[5.1]
  def change
    drop_table :work_contributions
  end
end
