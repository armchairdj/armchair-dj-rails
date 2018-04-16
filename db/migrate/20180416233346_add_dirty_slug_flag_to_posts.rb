class AddDirtySlugFlagToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :dirty_slug, :boolean, default: false, null: false
  end
end
