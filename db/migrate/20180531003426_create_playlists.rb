class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.string :title

      t.bigint :author_id

      t.string :alpha, index: true

      t.string :slug
      t.boolean :dirty_slug, default: false, null: false

      t.text :summary

      t.integer :unviewable_post_count, null: false, default: 0, index: true
      t.integer :viewable_post_count,     null: false, default: 0, index: true

      t.timestamps
    end

    add_index :playlists, :slug, unique: true
    add_foreign_key :playlists, :users, column: "author_id"
  end
end
