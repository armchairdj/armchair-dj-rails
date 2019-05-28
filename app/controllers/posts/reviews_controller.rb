# frozen_string_literal: true

module Posts
  class ReviewsController < Posts::BaseController
    private

    def set_section
      @section = :reviews
    end
  end
end
