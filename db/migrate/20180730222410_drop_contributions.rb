# frozen_string_literal: true

class DropContributions < ActiveRecord::Migration[5.2]
  def up
    drop_table :contributions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
