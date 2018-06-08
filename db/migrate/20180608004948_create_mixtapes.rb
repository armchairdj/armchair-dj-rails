class CreateMixtapes < ActiveRecord::Migration[5.2]
  def change
    create_table :mixtapes do |t|
      t.references :author, index: true, foreign_key: { to_table: :users }
      t.references :playlist, foreign_key: true, index: true

      t.text :body
      t.text :summary

      t.string :alpha, index: true
      t.string :slug
      t.boolean :dirty_slug, default: false, null: false

      t.integer :status, index: true, default: 0, null: false
      t.datetime :publish_on
      t.datetime :published_at

      t.timestamps
    end

    add_index :mixtapes, :slug, unique: true
  end
end
