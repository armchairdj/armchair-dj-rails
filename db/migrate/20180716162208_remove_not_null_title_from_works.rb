class RemoveNotNullTitleFromWorks < ActiveRecord::Migration[5.2]
  def change
    change_column_null :works, :title, true
  end
end
