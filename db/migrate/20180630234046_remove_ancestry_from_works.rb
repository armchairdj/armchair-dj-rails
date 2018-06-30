class RemoveAncestryFromWorks < ActiveRecord::Migration[5.2]
  def change
    remove_column :works, :ancestry
    remove_column :works, :ancestry_depth
  end
end
