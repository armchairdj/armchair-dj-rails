# frozen_string_literal: true

module PostsHelper
  def preview_admin_post_path(post)
    return preview_admin_article_path(post) if post.is_a?(Article)
    return preview_admin_review_path(post)  if post.is_a?(Review)
    return preview_admin_mixtape_path(post) if post.is_a?(Mixtape)
  end

  def edit_admin_post_path(post)
    return edit_admin_article_path(post) if post.is_a?(Article)
    return edit_admin_review_path(post)  if post.is_a?(Review)
    return edit_admin_mixtape_path(post) if post.is_a?(Mixtape)
  end

  def link_to_post(post, **opts)
    return link_to_article(post, **opts) if post.is_a?(Article)
    return link_to_review(post, **opts) if post.is_a?(Review)
    return link_to_mixtape(post, **opts) if post.is_a?(Mixtape)
  end

  def url_for_post(post, **opts)
    return uri_for_article(post, **opts) if post.is_a?(Article)
    return uri_for_review(post, **opts) if post.is_a?(Review)
    return uri_for_mixtape(post, **opts) if post.is_a?(Mixtape)
  end

  #############################################################################
  # DISPLAY METHODS.
  #############################################################################

  def decorated_post_type(post)
    return decorated_article_type(post) if post.is_a?(Article)
    return decorated_review_type(post) if post.is_a?(Review)
    return decorated_mixtape_type(post) if post.is_a?(Mixtape)
  end

  def post_title(post, **args)
    return article_title(post, **args) if post.is_a?(Article)
    return review_title(post, **args) if post.is_a?(Review)
    return mixtape_title(post, **args) if post.is_a?(Mixtape)
  end

  def post_body(post)
    content_tag_unless_empty(:div, post.formatted_body, class: "post-body")
  end

  def post_published_date(post)
    date_tag(post.published_at, pubdate: "pubdate") if post.published?
  end

  #############################################################################
  # ICON METHODS.
  #############################################################################

  def post_status_icon(post)
    return post_draft_icon     if post.draft?
    return post_scheduled_icon if post.scheduled?
    return post_published_icon if post.published?
  end

  def post_draft_icon
    wrapped_icon("lock-locked", title: "draft", desc: "draft icon", wrapper_class: "post-draft")
  end

  def post_published_icon
    wrapped_icon("lock-unlocked", title: "published", desc: "published icon", wrapper_class: "post-published")
  end

  def post_scheduled_icon
    wrapped_icon("clock", title: "scheduled to be published", desc: "scheduled icon", wrapper_class: "post-scheduled")
  end
end
