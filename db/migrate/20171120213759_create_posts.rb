class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.datetime :published_at
      t.references :postable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
