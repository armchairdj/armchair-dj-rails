class CreateWorkVersionings < ActiveRecord::Migration[5.2]
  def change
    create_table :work_versionings do |t|
      t.references :original, index: true, foreign_key: { to_table: :works }
      t.references :revision, index: true, foreign_key: { to_table: :works }

      t.timestamps
    end
  end
end
