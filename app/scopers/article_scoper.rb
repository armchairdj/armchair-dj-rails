# frozen_string_literal: true

class ArticleScoper < PostScoper
private

  def model_class
    Article
  end
end
