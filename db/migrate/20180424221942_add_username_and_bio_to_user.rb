class AddUsernameAndBioToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :username, :string, null: false
    add_column :users, :bio, :text

    add_index :users, :username, unique: true
  end
end
