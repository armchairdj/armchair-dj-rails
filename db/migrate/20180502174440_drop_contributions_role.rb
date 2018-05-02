class DropContributionsRole < ActiveRecord::Migration[5.2]
  def change
    remove_column :contributions, :role, :integer, null: false, default: 1
  end
end
