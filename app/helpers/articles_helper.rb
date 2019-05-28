# frozen_string_literal: true

module ArticlesHelper
  def decorated_article_type(article)
    [
      semantic_icon("justify-left", title: "article", desc: "article icon"),
      content_tag(:span, article.display_type)
    ].join.html_safe
  end

  def article_title(article, length: nil, full: false)
    return article.title if full

    smart_truncate(article.title, length: length)
  end

  def link_to_article(article, admin: false, full_url: false, text: nil, length: nil, **opts)
    return unless (url = uri_for_article(article, admin: admin, full_url: full_url))

    text ||= article_title(article, length: length)

    link_to(text, url, **opts)
  end

  def uri_for_article(article, admin: false, **opts)
    if admin
      uri_for_admin_article(article, **opts)
    elsif article.published?
      uri_for_public_article(article, **opts)
    end
  end

  def uri_for_admin_article(article, full_url: false, format: nil)
    return admin_article_url(article, format: format) if full_url

    admin_article_path(article, format: format)
  end

  def uri_for_public_article(article, full_url: false, format: nil)
    return article_url(article.slug, format: format) if full_url

    article_path(article.slug, format: format)
  end
end
