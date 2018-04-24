class AddSubtitleAndVersionToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :subtitle, :string
  end
end
