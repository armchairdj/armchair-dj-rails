class CreateWorkContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :work_contributions do |t|
      t.belongs_to :work, index: true
      t.belongs_to :creator, index: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
