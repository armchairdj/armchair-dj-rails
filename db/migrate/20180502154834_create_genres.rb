class CreateGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :genres do |t|
      t.references :medium,  index: true
      t.string :name
      t.string :alpha, index: true
      t.text :summary

      t.timestamps
    end

    add_foreign_key :genres, :media
  end
end
