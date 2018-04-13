class AddStatusToPosts < ActiveRecord::Migration[5.1]
  def up
    add_column :posts, :status, :integer, default: 0, null: false
    add_index :posts, :status
  end

  def down
    remove_column :posts, :status
  end
end
