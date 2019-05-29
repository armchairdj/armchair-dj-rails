# frozen_string_literal: true

class AddNamespaceToMilestones < ActiveRecord::Migration[5.2]
  def change
    rename_table :milestones, :work_milestones
  end
end
