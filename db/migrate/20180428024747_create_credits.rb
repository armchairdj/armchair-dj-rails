class CreateCredits < ActiveRecord::Migration[5.1]
  def change
    create_table :credits do |t|
      t.references :creator, foreign_key: true, index: true
      t.references :work,    foreign_key: true, index: true

      t.timestamps
    end
  end
end
