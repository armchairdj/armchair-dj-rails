class AddDisplayMakersToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :display_makers, :string
  end
end
