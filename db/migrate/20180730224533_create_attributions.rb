class CreateAttributions < ActiveRecord::Migration[5.2]
  def change
    create_table :attributions do |t|
      t.string :type

      t.references :creator, foreign_key: true
      t.references :work,    foreign_key: true
      t.references :role,    foreign_key: true, null: true

      t.string :alpha, index: true

      t.integer :position

      t.timestamps
    end
  end
end
