class RemoveDefaultRoleFromContributions < ActiveRecord::Migration[5.1]
  def change
    change_column_default :contributions, :role, nil
  end
end
