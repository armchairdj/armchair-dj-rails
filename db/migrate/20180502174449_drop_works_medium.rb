class DropWorksMedium < ActiveRecord::Migration[5.2]
  def change
    remove_column :works, :medium, :integer, null: false
  end
end
