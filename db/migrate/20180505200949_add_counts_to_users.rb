class AddCountsToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :non_viewable_post_count, :integer, null: false, default: 0
    add_column :users, :viewable_post_count,     :integer, null: false, default: 0

    add_index :users, :non_viewable_post_count
    add_index :users, :viewable_post_count
  end

  def down
    remove_column :users, :non_viewable_post_count
    remove_column :users, :viewable_post_count
  end
end
