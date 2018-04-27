class AddPrimaryToCreators < ActiveRecord::Migration[5.1]
  def change
    add_column :creators, :primary, :boolean, null: false, default: false
    add_index :creators, :primary
  end
end
