class AddCountsToWorks < ActiveRecord::Migration[5.1]
  def up
    add_column :works, :unviewable_post_count, :integer, null: false, default: 0
    add_column :works, :viewable_post_count,     :integer, null: false, default: 0

    add_index :works, :unviewable_post_count
    add_index :works, :viewable_post_count
  end

  def down
    remove_column :works, :unviewable_post_count
    remove_column :works, :viewable_post_count
  end
end
