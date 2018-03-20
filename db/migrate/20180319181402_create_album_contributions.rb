class CreateAlbumContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :album_contributions do |t|
      t.belongs_to :album, index: true
      t.belongs_to :artist, index: true
      t.integer :contribution, null: false, default: 0

      t.timestamps
    end
  end
end
