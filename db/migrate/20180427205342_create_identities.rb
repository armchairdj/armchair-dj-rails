class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.references :real_name, index: true
      t.references :pseudonym, index: true

      t.timestamps
    end

    add_foreign_key :identities, :creators, column: :real_name_id
    add_foreign_key :identities, :creators, column: :pseudonym_id
  end
end
