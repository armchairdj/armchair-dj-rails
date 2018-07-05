class ChangeWorkTypeToMedium < ActiveRecord::Migration[5.2]
  def change
    rename_column :works, :type, :medium
  end
end
