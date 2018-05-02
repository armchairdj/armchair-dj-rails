class AddWorksMedium < ActiveRecord::Migration[5.2]
  def change
    change_table :works do |t|
      t.references :medium, foreign_key: true, index: true
    end
  end
end
