class CreateAlbumContributors < ActiveRecord::Migration[5.1]
  def change
    create_table :album_contributors do |t|
      t.belongs_to :album, index: true
      t.belongs_to :artist, index: true

      t.timestamps
    end
  end
end
