class AddCollectiveToCreators < ActiveRecord::Migration[5.1]
  def change
    add_column :creators, :collective, :boolean, null: false, default: false
    add_index :creators, :collective
  end
end
