# frozen_string_literal: true

module ArticlesHelper
  def decorated_article_type(article)
    [
      semantic_icon("justify-left", title: "article", desc: "article icon"),
      content_tag(:span, article.display_type)
    ].join.html_safe
  end

  def article_title(article, length: nil, full: true)
    smart_truncate(article.title, length: length)
  end

  def link_to_article(article, admin: false, full_url: false, text: nil, length: nil, **opts)
    return unless url = url_for_article(article, admin: admin, full_url: full_url)

    text ||= article_title(article, length: length)

    link_to(text, url, **opts)
  end

  def url_for_article(article, admin: false, full_url: false, format: nil)
    if admin
      if full_url
        admin_article_url(article, format: format)
      else
        admin_article_path(article, format: format)
      end
    elsif article.published?
      if full_url
        article_url(article.slug, format: format)
      else
        article_path(article.slug, format: format)
      end
    end
  end
end
