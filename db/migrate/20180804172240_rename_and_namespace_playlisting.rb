class RenameAndNamespacePlaylisting < ActiveRecord::Migration[5.2]
  def change
    rename_table :playlistings, :playlist_tracks
  end
end
