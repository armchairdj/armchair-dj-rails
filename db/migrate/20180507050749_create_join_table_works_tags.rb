class CreateJoinTableWorksTags < ActiveRecord::Migration[5.2]
  def change
    create_join_table :works, :tags do |t|
      t.index [:work_id, :tag_id]
      t.index [:tag_id, :work_id]
    end
  end
end
