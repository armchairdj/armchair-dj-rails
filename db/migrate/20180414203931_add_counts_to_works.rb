class AddCountsToWorks < ActiveRecord::Migration[5.1]
  def up
    add_column :works, :non_viewable_post_count, :integer, null: false, default: 0
    add_column :works, :viewable_post_count,     :integer, null: false, default: 0

    add_index :works, :non_viewable_post_count
    add_index :works, :viewable_post_count

    Work.all.each { |w| w.save }
  end

  def down
    remove_column :works, :non_viewable_post_count
    remove_column :works, :viewable_post_count
  end
end
