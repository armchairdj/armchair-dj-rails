class AddAlphaColumnToSortableModels < ActiveRecord::Migration[5.2]
  def change
    add_column :contributions, :alpha, :string, null: false
    add_column :credits,       :alpha, :string, null: false
    add_column :creators,      :alpha, :string, null: false
    add_column :works,         :alpha, :string, null: false
    add_column :users,         :alpha, :string, null: false
    add_column :posts,         :alpha, :string, null: false

    add_index :contributions,  :alpha
    add_index :credits,        :alpha
    add_index :creators,       :alpha
    add_index :works,          :alpha
    add_index :users,          :alpha
    add_index :posts,          :alpha
  end
end
