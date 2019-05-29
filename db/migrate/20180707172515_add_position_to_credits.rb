# frozen_string_literal: true

class AddPositionToCredits < ActiveRecord::Migration[5.2]
  def change
    add_column :credits, :position, :integer
  end
end
