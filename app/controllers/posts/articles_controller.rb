# frozen_string_literal: true

module Posts
  class ArticlesController < Posts::PublicController
    private

    def set_section
      @section = :articles
    end
  end
end
