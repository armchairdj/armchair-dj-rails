class AddPublicFieldsToTags < ActiveRecord::Migration[5.2]
  def up
    add_column :tags, :summary, :text
    add_column :tags, :unviewable_post_count, :integer, null: false, default: 0
    add_column :tags, :viewable_post_count,     :integer, null: false, default: 0

    add_index :tags, :unviewable_post_count
    add_index :tags, :viewable_post_count
  end

  def down
    remove_column :tags, :summary
    remove_column :tags, :unviewable_post_count
    remove_column :tags, :viewable_post_count
  end
end
