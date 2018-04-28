class AddStatusToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :status, :integer, default: 0, null: false
    add_index :posts, :status
  end
end
