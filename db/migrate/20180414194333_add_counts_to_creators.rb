class AddCountsToCreators < ActiveRecord::Migration[5.1]
  def up
    add_column :creators, :unviewable_post_count, :integer, null: false, default: 0
    add_column :creators, :viewable_post_count,     :integer, null: false, default: 0

    add_index :creators, :unviewable_post_count
    add_index :creators, :viewable_post_count
  end

  def down
    remove_column :creators, :unviewable_post_count
    remove_column :creators, :viewable_post_count
  end
end
