# frozen_string_literal: true

module Posts
  class MixtapesController < Posts::PublicController
    private

    def set_section
      @section = :mixtapes
    end
  end
end
