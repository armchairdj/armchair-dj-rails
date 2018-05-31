class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.references :playlist
      t.references :work
      t.integer :position

      t.timestamps
    end
  end
end
