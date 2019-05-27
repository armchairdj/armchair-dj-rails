# frozen_string_literal: true

class TagScoper < Ginsu::Scoper
private

  def model_class
    Tag
  end
end
