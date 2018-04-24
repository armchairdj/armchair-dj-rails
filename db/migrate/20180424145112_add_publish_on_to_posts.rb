class AddPublishOnToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :publish_on, :datetime
  end
end
