# frozen_string_literal: true

module ReviewsHelper
  def review_title(review, length: nil, full: true)
    smart_truncate(review.work.display_title(full: full), length: length)
  end

  def link_to_review(review, admin: false, full_url: false, text: nil, full: true, length: nil, **opts)
    return unless url = url_for_review(review, admin: admin, full_url: full_url)

    text ||= review_title(review, full: full, length: length)

    link_to(text, url, **opts)
  end

  def url_for_review(review, admin: false, full_url: false, format: nil)
    if admin
      if full_url
        admin_review_url(review, format: format)
      else
        admin_review_path(review, format: format)
      end
    elsif review.published?
      if full_url
        review_url(review.slug, format: format)
      else
        review_path(review.slug, format: format)
      end
    end
  end
end
