# frozen_string_literal: true

class RenameApsectColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :aspects, :facet, :key
    rename_column :aspects, :name, :val
  end
end
