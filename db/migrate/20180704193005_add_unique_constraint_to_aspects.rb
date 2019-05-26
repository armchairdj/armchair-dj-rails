# frozen_string_literal: true

class AddUniqueConstraintToAspects < ActiveRecord::Migration[5.2]
  def change
    add_index :aspects_works, [:work_id, :aspect_id], unique: true, name: "by_work_and_aspect"
  end
end
