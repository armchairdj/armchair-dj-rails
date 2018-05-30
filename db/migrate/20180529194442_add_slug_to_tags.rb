class AddSlugToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :slug, :string
    add_column :tags, :dirty_slug, :boolean, default: false, null: false
    add_index :tags, :slug, unique: true
  end
end
