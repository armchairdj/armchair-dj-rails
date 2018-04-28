class ChangeCreatorsPrimaryDefault < ActiveRecord::Migration[5.2]
  def up
    change_column_default :creators, :primary, true
  end

  def down
    change_column_default :creators, :primary, false
  end
end
