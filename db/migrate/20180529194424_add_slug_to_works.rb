class AddSlugToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :slug, :string
    add_column :works, :dirty_slug, :boolean, default: false, null: false
    add_index :works, :slug, unique: true
  end
end
