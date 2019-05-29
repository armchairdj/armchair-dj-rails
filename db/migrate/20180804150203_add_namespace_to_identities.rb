# frozen_string_literal: true

class AddNamespaceToIdentities < ActiveRecord::Migration[5.2]
  def change
    rename_table :identities, :creator_identities
  end
end
