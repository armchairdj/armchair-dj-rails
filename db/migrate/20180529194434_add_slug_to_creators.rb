class AddSlugToCreators < ActiveRecord::Migration[5.2]
  def change
    add_column :creators, :slug, :string
    add_column :creators, :dirty_slug, :boolean, default: false, null: false
    add_index :creators, :slug, unique: true
  end
end
