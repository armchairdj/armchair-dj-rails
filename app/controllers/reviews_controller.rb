# frozen_string_literal: true

class ReviewsController < PublicController

private

  def find_collection
    @reviews = scoped_collection
  end

  def find_instance
    @review = scoped_instance
  end
end
