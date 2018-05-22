# frozen_string_literal: true

class Admin::MediumPolicy < AdminPolicy
  def reorder_facets?
    update?
  end
end
