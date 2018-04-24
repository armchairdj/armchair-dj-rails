class AddUserToPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :user

    Post.update_all(user_id: User.first.id)

    change_column :posts, :user_id, :integer, null: false
  end
end
