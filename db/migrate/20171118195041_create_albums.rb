class CreateWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :works do |t|
      t.belongs_to :creator, index: true
      t.string :title, null: false

      t.timestamps
    end
  end
end
