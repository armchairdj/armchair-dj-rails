class AddSlugToPosts < ActiveRecord::Migration[5.1]
  def up
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true

    Post.all.each do |post|
      post.send(:handle_slug)
      post.save
    end
  end

  def down
    remove_column :posts, :slug
  end
end
