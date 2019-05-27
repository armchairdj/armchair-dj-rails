# frozen_string_literal: true

class Posts::ArticlesController < Posts::BaseController
private

  def set_section
    @section = :articles
  end
end
