class CreateMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :milestones do |t|
      t.references :work, index: true, foreign_key: { to_table: :works }
      t.integer :action, null: false, default: 0, index: true
      t.integer :year

      t.timestamps
    end
  end
end
