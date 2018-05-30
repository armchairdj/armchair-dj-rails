# frozen_string_literal: true

module PostsHelper
  include UsersHelper

  #############################################################################
  # DISPLAY METHODS.
  #############################################################################

  def formatted_post_body(post)
    paragraphs(post.body)
  end

  def post_published_date(post)
    return unless post.published?

    time_tag(post.published_at, post.published_at.strftime("%m/%d/%Y at %I:%M%p"), pubdate: "pubdate")
  end

  def post_scheduled_date(post)
    return unless post.scheduled?

    time_tag post.publish_on, post.publish_on.strftime("%m/%d/%Y at %I:%M%p")
  end

  def post_title(post, full: true, length: nil)
    title = post.review? ? post.work.display_title(full: full) : post.title

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

  def link_to_post(instance, admin: false, full: true, **opts)
    return unless admin || instance.published?

    text = post_title(instance, full: full)
    url  = admin ? admin_post_path(instance) : post_permalink_path(slug: instance.slug)

    link_to(text, url, **opts)
  end

  def link_to_post_author(post)
    return unless link = link_to_user(post.author, rel: "author")

    content_tag(:address, link, class: "author")
  end
end
