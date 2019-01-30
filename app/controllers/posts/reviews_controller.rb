# frozen_string_literal: true

class Posts::ReviewsController < Posts::BaseController

private

  def set_section
    @section = :reviews
  end
end
