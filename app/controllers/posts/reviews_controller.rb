# frozen_string_literal: true

module Posts
  class ReviewsController < Posts::PublicController
    private

    def set_section
      @section = :reviews
    end
  end
end
