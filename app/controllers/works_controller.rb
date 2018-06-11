# frozen_string_literal: true

class WorksController < PublicController

private

  def find_collection
    @works = scoped_collection
  end

  def find_instance
    @work = scoped_instance
  end
end
