class AddCharacteristicToAspect < ActiveRecord::Migration[5.2]
  def change
    remove_column :aspects, :category_id
    add_column :aspects, :characteristic, :integer, null: false

    add_index :aspects, :characteristic
  end
end
