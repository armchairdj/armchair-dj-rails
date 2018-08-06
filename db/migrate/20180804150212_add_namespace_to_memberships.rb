class AddNamespaceToMemberships < ActiveRecord::Migration[5.2]
  def change
    rename_table :memberships, :creator_memberships
  end
end
