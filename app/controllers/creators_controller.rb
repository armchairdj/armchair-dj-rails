# frozen_string_literal: true

class CreatorsController < PublicController

private

  def find_collection
    @creators = scoped_collection
  end

  def find_instance
    @creator = scoped_instance
  end
end
