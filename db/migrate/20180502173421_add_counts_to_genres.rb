class AddCountsToGenres < ActiveRecord::Migration[5.2]
  def up
    add_column :genres, :non_viewable_post_count, :integer, null: false, default: 0
    add_column :genres, :viewable_post_count,     :integer, null: false, default: 0

    add_index :genres, :non_viewable_post_count
    add_index :genres, :viewable_post_count
  end

  def down
    remove_column :genres, :non_viewable_post_count
    remove_column :genres, :viewable_post_count
  end
end
