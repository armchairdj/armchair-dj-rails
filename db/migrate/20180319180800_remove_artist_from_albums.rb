class RemoveArtistFromAlbums < ActiveRecord::Migration[5.1]
  def change
    remove_reference :albums, :artist, index: true
  end
end
