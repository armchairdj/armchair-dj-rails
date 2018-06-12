class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.text :summary
      t.string :alpha, index: true
      t.string :slug
      t.boolean :viewable, default: false, null: false

      t.timestamps
    end
  end
end
