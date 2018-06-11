# frozen_string_literal: true

class MixtapesController < PublicController

private

  def find_collection
    @mixtapes = scoped_collection
  end

  def find_instance
    @mixtape = scoped_instance_by_slug
  end
end
