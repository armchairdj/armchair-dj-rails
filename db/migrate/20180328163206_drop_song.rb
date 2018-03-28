class DropWork < ActiveRecord::Migration[5.1]
  def change
    drop_table :works
  end
end
