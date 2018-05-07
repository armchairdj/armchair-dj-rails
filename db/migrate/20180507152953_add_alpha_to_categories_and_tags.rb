class AddAlphaToCategoriesAndTags < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :alpha, :string
    add_column :tags,       :alpha, :string

    add_index :categories,  :alpha
    add_index :tags,        :alpha
  end
end
