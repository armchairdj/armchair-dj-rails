class RemoveArtistFromSongs < ActiveRecord::Migration[5.1]
  def change
    remove_reference :songs, :artist, index: true
  end
end
