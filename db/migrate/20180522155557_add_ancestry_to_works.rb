class AddAncestryToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :ancestry, :string
    add_column :works, :ancestry_depth, :integer, default: 0
    add_index :works, :ancestry
  end
end
