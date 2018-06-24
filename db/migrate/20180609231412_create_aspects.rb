class CreateAspects < ActiveRecord::Migration[5.2]
  def change
    create_table :aspects do |t|
      t.string :name
      t.integer :facet, null: false, index: true
      t.string :alpha, index: true

      t.timestamps
    end

    add_index :aspects, :slug, unique: true
  end
end
