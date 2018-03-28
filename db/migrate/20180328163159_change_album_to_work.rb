class ChangeWorkToWork < ActiveRecord::Migration[5.1]
  def change
    rename_table :works, :works
  end
end
