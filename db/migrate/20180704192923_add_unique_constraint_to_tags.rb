# frozen_string_literal: true

class AddUniqueConstraintToTags < ActiveRecord::Migration[5.2]
  def change
    add_index :posts_tags, [ :post_id, :tag_id ], unique: true, name: "by_post_and_tag"
  end
end
