# frozen_string_literal: true

module Viewable
  extend ActiveSupport::Concern

  included do
    before_save :refresh_counts

    scope     :viewable, -> { where.not(viewable_post_count: 0) }
    scope :non_viewable, -> {     where(viewable_post_count: 0) }
  end

  class_methods do
    def admin_scopes
      {
        "Viewable"     => :viewable,
        "Non-Viewable" => :non_viewable,
        "All"          => :all
      }
    end
  end

  def viewable?
    self.viewable_post_count > 0
  end

  def non_viewable?
    self.viewable_post_count == 0
  end

  def viewable_posts
    self.posts.published.reverse_cron
  end

  def non_viewable_posts
    self.posts.not_published.reverse_cron
  end

  def viewable_works
    self.viewable_posts.map(&:work).uniq
  end

  def non_viewable_works
    self.non_viewable_posts.map(&:work).uniq
  end

  def update_counts
    refresh_counts && save
  end

private

  def refresh_counts
    self.non_viewable_post_count = posts.not_published.count
    self.viewable_post_count     = posts.published.count

    non_viewable_post_count_changed? || viewable_post_count_changed?
  end
end
