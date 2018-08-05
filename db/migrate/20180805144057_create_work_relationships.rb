class CreateWorkRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :work_relationships do |t|
      t.references :target, null: false, index: true, foreign_key: { to_table: :works }

      t.integer :correlation, null: false

      t.references :source, null: false, index: true, foreign_key: { to_table: :works }

      t.timestamps
    end
  end
end
