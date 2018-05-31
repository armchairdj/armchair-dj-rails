class AddCountsToMedia < ActiveRecord::Migration[5.2]
  def up
    add_column :media, :unviewable_post_count, :integer, null: false, default: 0
    add_column :media, :viewable_post_count,     :integer, null: false, default: 0

    add_index :media, :unviewable_post_count
    add_index :media, :viewable_post_count
  end

  def down
    remove_column :media, :unviewable_post_count
    remove_column :media, :viewable_post_count
  end
end
