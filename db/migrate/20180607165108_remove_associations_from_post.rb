class RemoveAssociationsFromPost < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :work_id,     :bigint
    remove_column :posts, :playlist_id, :bigint
  end
end
