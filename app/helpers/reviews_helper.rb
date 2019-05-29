# frozen_string_literal: true

module ReviewsHelper
  def decorated_review_type(review)
    [
      semantic_icon("thumb-up", title: "review", desc: "review icon"),
      content_tag(:span, review.display_type)
    ].join.html_safe
  end

  def review_title(review, length: nil, full: true)
    smart_truncate(review.work.display_title(full: full), length: length)
  end

  def link_to_review(review, admin: false, full_url: false, text: nil, full: true, length: nil, **opts)
    return unless (url = uri_for_review(review, admin: admin, full_url: full_url))

    text ||= review_title(review, full: full, length: length)

    link_to(text, url, **opts)
  end

  def uri_for_review(review, admin: false, **opts)
    if admin
      uri_for_admin_review(review, **opts)
    elsif review.published?
      uri_for_public_review(review, **opts)
    end
  end

  def uri_for_admin_review(review, full_url: false, format: nil)
    return admin_review_url(review, format: format) if full_url

    admin_review_path(review, format: format)
  end

  def uri_for_public_review(review, full_url: false, format: nil)
    return review_url(review.slug, format: format) if full_url

    review_path(review.slug, format: format)
  end
end
