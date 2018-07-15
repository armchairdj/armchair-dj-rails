# frozen_string_literal: true

module PostsHelper

  #############################################################################
  # DISPLAY METHODS.
  #############################################################################

  def formatted_post_body(post)
    markdown = Redcarpet::Markdown.new(SmartRender)

    markdown.render(post.body)
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

  def post_status_and_date(post)
    return post.human_status if post.draft?

    date = admin_date(post.publish_date, pubdate: "pubdate")
    conn = post.scheduled? ? "for" : "on"

    "#{post.human_status} #{conn} #{date}".html_safe
  end

  def post_published_date(post)
    return unless post.published?

    date      = post.published_at
    formatted = l(date)

    time_tag(date, formatted, pubdate: "pubdate")
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

  def link_to_post(post, **opts)
    return link_to_article(post, **opts) if post.is_a?(Article)
    return link_to_review( post, **opts) if post.is_a?(Review)
    return link_to_mixtape(post, **opts) if post.is_a?(Mixtape)
  end
end
