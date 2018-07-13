# frozen_string_literal: true

module ReviewsHelper
  def review_title(review, full: true, length: nil)
    smart_truncate(review.work.display_title(full: full), length: length)
  end

  def link_to_review(review, admin: false, full: true, length: nil, **opts)
    return unless admin || review.published?

    text = review_title(review, full: full, length: length)
    url  = admin ? admin_review_path(review) : review_path(review.slug)

    link_to(text, url, **opts)
  end
end
