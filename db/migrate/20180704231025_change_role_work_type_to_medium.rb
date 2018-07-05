class ChangeRoleWorkTypeToMedium < ActiveRecord::Migration[5.2]
  def change
    rename_column :roles, :medium, :medium
  end
end
