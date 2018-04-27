class CreateParticipations < ActiveRecord::Migration[5.1]
  def change
    create_table :participations do |t|
      t.references :creator,     foreign_key: false
      t.references :participant, foreign_key: false
      t.integer :relationship, null: false

      t.timestamps
    end
  end
end
