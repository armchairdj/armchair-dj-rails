class CreateJoinTableWorksAspects < ActiveRecord::Migration[5.2]
  def change
    create_join_table :works, :aspects do |t|
      t.index [:work_id, :aspect_id]
      t.index [:aspect_id, :work_id]
    end
  end
end
