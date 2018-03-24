class CreateSongContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :song_contributions do |t|
      t.belongs_to :song, index: true
      t.belongs_to :artist, index: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
