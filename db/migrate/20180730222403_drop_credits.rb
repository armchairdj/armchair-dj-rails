class DropCredits < ActiveRecord::Migration[5.2]
  def up
    drop_table :credits
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
