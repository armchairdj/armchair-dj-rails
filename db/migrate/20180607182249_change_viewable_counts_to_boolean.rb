class ChangeViewableCountsToBoolean < ActiveRecord::Migration[5.2]
  def change
    remove_column :users,       :viewable_post_count, :integer, default: 0, null: false
    remove_column :users,     :unviewable_post_count, :integer, default: 0, null: false

    remove_column :creators,    :viewable_post_count, :integer, default: 0, null: false
    remove_column :creators,  :unviewable_post_count, :integer, default: 0, null: false

    remove_column :media,       :viewable_post_count, :integer, default: 0, null: false
    remove_column :media,     :unviewable_post_count, :integer, default: 0, null: false

    remove_column :playlists,   :viewable_post_count, :integer, default: 0, null: false
    remove_column :playlists, :unviewable_post_count, :integer, default: 0, null: false

    remove_column :tags,        :viewable_post_count, :integer, default: 0, null: false
    remove_column :tags,      :unviewable_post_count, :integer, default: 0, null: false

    remove_column :works,       :viewable_post_count, :integer, default: 0, null: false
    remove_column :works,     :unviewable_post_count, :integer, default: 0, null: false

    add_column :users,     :viewable, :boolean, default: false, null: false
    add_column :creators,  :viewable, :boolean, default: false, null: false
    add_column :media,     :viewable, :boolean, default: false, null: false
    add_column :playlists, :viewable, :boolean, default: false, null: false
    add_column :tags,      :viewable, :boolean, default: false, null: false
    add_column :works,     :viewable, :boolean, default: false, null: false
  end
end
