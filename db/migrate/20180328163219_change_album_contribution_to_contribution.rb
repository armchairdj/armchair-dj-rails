class ChangeWorkContributionToContribution < ActiveRecord::Migration[5.1]
  def change
    rename_table :work_contributions, :contributions
    rename_column :contributions, :creator_id, :creator_id
    rename_column :contributions, :work_id, :work_id
  end
end
