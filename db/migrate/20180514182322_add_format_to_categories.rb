class AddFormatToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :format, :integer, null: false, default: 0
    add_index :categories, :format
  end
end
