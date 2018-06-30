class RenameMilestonesActionsToActivities < ActiveRecord::Migration[5.2]
  def change
    rename_column :milestones, :action, :activity
  end
end
