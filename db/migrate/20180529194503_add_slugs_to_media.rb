class AddSlugsToMedia < ActiveRecord::Migration[5.2]
  def change
    add_column :media, :slug, :string
    add_column :media, :dirty_slug, :boolean, default: false, null: false
    add_index :media, :slug, unique: true
  end
end
