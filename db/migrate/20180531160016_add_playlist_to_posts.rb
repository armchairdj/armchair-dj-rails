class AddPlaylistToPosts < ActiveRecord::Migration[5.2]
  def change
    change_table :posts do |t|
      t.references :playlist, index: true
    end

    add_foreign_key :posts, :playlists
  end
end
