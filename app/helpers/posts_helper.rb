# frozen_string_literal: true

module PostsHelper

  #############################################################################
  # DISPLAY METHODS.
  #############################################################################

  def formatted_post_body(post)
    paragraphs(post.body)
  end

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

  def post_published_date(post)
    return unless post.published?

    time_tag(post.published_at, post.published_at.strftime("%m/%d/%Y at %I:%M%p"), pubdate: "pubdate")
  end

  def post_scheduled_date(post)
    return unless post.scheduled?

    time_tag post.publish_on, post.publish_on.strftime("%m/%d/%Y at %I:%M%p")
  end

  def smart_truncate(title, length: nil)
    length.nil? ? title : truncate(title, length: length, omission: "…")
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

  #############################################################################
  # LINK METHODS.
  #############################################################################

  def link_to_post_author(post)
    return unless link = link_to_user(post.author, rel: "author")

    content_tag(:address, link, class: "author")
  end

  def link_to_post(post, **opts)
    return link_to_article(post, **opts) if post.is_a?(Article)
    return link_to_review( post, **opts) if post.is_a?(Review)
    return link_to_mixtape(post, **opts) if post.is_a?(Mixtape)
  end
end
