class AddIndividualToCreators < ActiveRecord::Migration[5.1]
  def change
    add_column :creators, :individual, :boolean, null: false, default: true
    add_index :creators, :individual
  end
end
