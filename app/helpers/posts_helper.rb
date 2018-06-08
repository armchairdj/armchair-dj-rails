# frozen_string_literal: true

module PostsHelper
  include UsersHelper

  #############################################################################
  # DISPLAY METHODS.
  #############################################################################

  def formatted_post_body(article)
    paragraphs(article.body)
  end

  def post_published_date(article)
    return unless article.published?

    time_tag(article.published_at, article.published_at.strftime("%m/%d/%Y at %I:%M%p"), pubdate: "pubdate")
  end

  def post_scheduled_date(article)
    return unless article.scheduled?

    time_tag article.publish_on, article.publish_on.strftime("%m/%d/%Y at %I:%M%p")
  end

  def truncated_title(title, length: nil)
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
end
