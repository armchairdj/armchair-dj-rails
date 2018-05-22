class AddPositionToFacet < ActiveRecord::Migration[5.2]
  def change
    add_column :facets, :position, :integer

    Medium.all.each do |medium|
      medium.facets.order(:updated_at).each.with_index(0) do |facet, index|
        facet.update_column :position, index
      end
    end
  end
end
