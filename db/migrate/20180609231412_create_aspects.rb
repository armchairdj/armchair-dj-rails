class CreateAspects < ActiveRecord::Migration[5.2]
  def change
    create_table :aspects do |t|
      t.string :name
      t.text :summary
      t.string :alpha, index: true
      t.string :slug
      t.boolean :dirty_slug, default: false, null: false
      t.boolean :viewable, default: false, null: false
      t.references :category, index: true, foreign_key: { to_table: :categories }

      t.timestamps
    end

    add_index :aspects, :slug, unique: true
  end
end
