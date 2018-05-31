# frozen_string_literal: true

module Viewable
  extend ActiveSupport::Concern

  #############################################################################
  # SCOPES.
  #############################################################################

  included do
    scope     :viewable, -> { eager.where.not(viewable_post_count: 0) }
    scope :unviewable, -> { eager.where(    viewable_post_count: 0) }

    before_save :refresh_counts
  end

  #############################################################################
  # HOOKS.
  #############################################################################

  # Public method called from Post.
  def update_counts
    refresh_counts && save
  end

  def refresh_counts
    self.unviewable_post_count = posts.not_published.count
    self.viewable_post_count     = posts.published.count

    unviewable_post_count_changed? || viewable_post_count_changed?
  end

  private :refresh_counts

  #############################################################################
  # INSTANCE.
  #############################################################################

  def viewable?
    self.viewable_post_count > 0
  end

  def unviewable?
    !viewable?
  end

  def viewable_posts
    self.posts.published.reverse_cron
  end

  def unviewable_posts
    self.posts.not_published.reverse_cron
  end

  def viewable_works
    self.viewable_posts.map(&:work).uniq
  end

  def unviewable_works
    self.unviewable_posts.map(&:work).uniq
  end
end
