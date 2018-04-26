class AddSummaryToWork < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :summary, :text
  end
end
