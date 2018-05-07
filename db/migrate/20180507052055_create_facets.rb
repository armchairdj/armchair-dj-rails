class CreateFacets < ActiveRecord::Migration[5.2]
  def change
    create_table :facets do |t|
      t.references :medium,  index: true
      t.references :category, index: true

      t.timestamps
    end

    add_foreign_key :facets, :media,      column: :medium_id
    add_foreign_key :facets, :categories, column: :category_id
  end
end
