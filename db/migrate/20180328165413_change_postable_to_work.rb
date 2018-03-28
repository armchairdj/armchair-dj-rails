class ChangePostableToWork < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :postable_type, :string
    rename_column :posts, :postable_id, :work_id 
  end
end
