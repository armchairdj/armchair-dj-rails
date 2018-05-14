class AddAllowMultipleToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :allow_multiple, :boolean, null: false, default: true
  end
end
