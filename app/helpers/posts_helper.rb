# frozen_string_literal: true

module PostsHelper

  def link_to_post(post, **opts)
    return link_to_article(post, **opts) if post.is_a?(Article)
    return link_to_review( post, **opts) if post.is_a?(Review)
    return link_to_mixtape(post, **opts) if post.is_a?(Mixtape)
  end

  def url_for_post(post, **opts)
    return url_for_article(post, **opts) if post.is_a?(Article)
    return url_for_review( post, **opts) if post.is_a?(Review)
    return url_for_mixtape(post, **opts) if post.is_a?(Mixtape)
  end

  #############################################################################
  # DISPLAY METHODS.
  #############################################################################

  def post_title(post, **args)
    case
    when post.is_a?(Article)
      article_title(post, **args)
    when post.is_a?(Review)
      review_title(post, **args)
    when post.is_a?(Mixtape)
      mixtape_title(post, **args)
    end
  end

  def post_body(post)
    content_tag_unless_empty(:div, post.formatted_body, class: "post-body")
  end

  def post_published_date(post)
    return unless post.published?

    time_tag(post.published_at, l(post.published_at), pubdate: "pubdate")
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
    svg_icon("lock-locked", title: "draft", desc: "draft icon", wrapper_class: "post-draft")
  end

  def post_published_icon
    svg_icon("lock-unlocked", title: "published", desc: "published icon", wrapper_class: "post-published")
  end

  def post_scheduled_icon
    svg_icon("clock", title: "scheduled to be published", desc: "scheduled icon", wrapper_class: "post-scheduled")
  end
end
