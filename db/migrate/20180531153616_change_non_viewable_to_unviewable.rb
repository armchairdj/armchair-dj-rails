class ChangeNonViewableToUnviewable < ActiveRecord::Migration[5.2]
  def change
    rename_column :creators,  :unviewable_post_count, :unviewable_post_count
    rename_column :media,     :unviewable_post_count, :unviewable_post_count
    rename_column :playlists, :unviewable_post_count, :unviewable_post_count
    rename_column :tags,      :unviewable_post_count, :unviewable_post_count
    rename_column :users,     :unviewable_post_count, :unviewable_post_count
    rename_column :works,     :unviewable_post_count, :unviewable_post_count
  end
end
