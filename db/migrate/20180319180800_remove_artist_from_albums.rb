class RemoveCreatorFromWorks < ActiveRecord::Migration[5.1]
  def change
    remove_reference :works, :creator, index: true
  end
end
