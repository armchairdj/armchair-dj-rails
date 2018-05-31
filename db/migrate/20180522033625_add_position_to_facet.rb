class AddPositionToFacet < ActiveRecord::Migration[5.2]
  def change
    add_column :facets, :position, :integer
  end
end
