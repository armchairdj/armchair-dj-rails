# frozen_string_literal: true

module ArticlesHelper
  def article_title(article, length: nil, **args)
    smart_truncate(article.title, length: length)
  end

  def link_to_article(article, admin: false, length: nil, **opts)
    return unless admin || article.published?

    text = article_title(article, length: length)
    url  = admin ? admin_article_path(article) : article_path(article)

    link_to(text, url, **opts)
  end
end
