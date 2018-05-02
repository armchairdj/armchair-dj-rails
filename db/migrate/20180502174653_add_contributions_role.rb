class AddContributionsRole < ActiveRecord::Migration[5.2]
  def change
    change_table :contributions do |t|
      t.references :role, foreign_key: true, index: true
    end
  end
end
