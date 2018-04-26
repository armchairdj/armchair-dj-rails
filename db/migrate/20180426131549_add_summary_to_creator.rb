class AddSummaryToCreator < ActiveRecord::Migration[5.1]
  def change
    add_column :creators, :summary, :text
  end
end
