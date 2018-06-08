class CreateJoinTableReviewsTags < ActiveRecord::Migration[5.2]
  def change
    create_join_table :reviews, :tags do |t|
      t.index [:review_id, :tag_id]
      t.index [:tag_id, :review_id]
    end
  end
end
