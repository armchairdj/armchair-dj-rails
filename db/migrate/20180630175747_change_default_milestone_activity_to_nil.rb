class ChangeDefaultMilestoneActivityToNil < ActiveRecord::Migration[5.2]
  def change
    change_column_default :milestones, :activity, nil
  end
end
