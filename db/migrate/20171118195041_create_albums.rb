class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.belongs_to :artist, index: true
      t.string :title, null: false

      t.timestamps
    end
  end
end
