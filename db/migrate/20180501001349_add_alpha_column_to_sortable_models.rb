class AddAlphaColumnToSortableModels < ActiveRecord::Migration[5.2]
  def change
    add_column :contributions, :alpha, :string
    add_column :credits,       :alpha, :string
    add_column :creators,      :alpha, :string
    add_column :works,         :alpha, :string
    add_column :users,         :alpha, :string
    add_column :posts,         :alpha, :string

    add_index :contributions,  :alpha
    add_index :credits,        :alpha
    add_index :creators,       :alpha
    add_index :works,          :alpha
    add_index :users,          :alpha
    add_index :posts,          :alpha
  end
end
