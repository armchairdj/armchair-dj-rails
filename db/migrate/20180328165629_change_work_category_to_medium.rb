class ChangeWorkCategoryToMedium < ActiveRecord::Migration[5.1]
  def change
    rename_column :works, :category, :medium
  end
end
