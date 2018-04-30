class CreateMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships do |t|
      t.references :group,  index: true
      t.references :member, index: true

      t.timestamps
    end

    add_foreign_key :memberships, :creators, column: :group_id
    add_foreign_key :memberships, :creators, column: :member_id
  end
end
