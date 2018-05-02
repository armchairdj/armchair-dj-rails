class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.references :medium,  index: true
      t.string :name

      t.timestamps
    end

    add_foreign_key :roles, :media
  end
end
