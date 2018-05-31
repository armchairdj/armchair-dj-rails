class RenameTracksToPlaylistings < ActiveRecord::Migration[5.2]
  def change
    rename_table :tracks, :playlistings
  end
end
