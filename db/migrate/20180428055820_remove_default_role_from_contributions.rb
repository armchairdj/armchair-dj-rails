class RemoveDefaultRoleFromContributions < ActiveRecord::Migration[5.1]
  def up
    change_column_default :contributions, :role, nil
  end

  def down
    change_column_default :contributions, :role, 0
  end
end
