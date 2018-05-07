class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.references :category, index: true

      t.string :name

      t.timestamps
    end

    add_foreign_key :tags, :categories, column: :category_id
  end
end
