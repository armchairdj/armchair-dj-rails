class AddCategoryToWork < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :category, :integer
  end
end
