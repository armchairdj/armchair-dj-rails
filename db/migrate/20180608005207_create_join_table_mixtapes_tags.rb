class CreateJoinTableMixtapesTags < ActiveRecord::Migration[5.2]
  def change
    create_join_table :mixtapes, :tags do |t|
      t.index [:mixtape_id, :tag_id]
      t.index [:tag_id, :mixtape_id]
    end
  end
end
