# frozen_string_literal: true

module Viewable
  extend ActiveSupport::Concern

  class_methods do
    def viewable_admin_sorts(always = nil)
      {
        "VPC"  => ["#{model_name.plural}.viewable_post_count ASC",     always].compact.join(", "),
        "NVPC" => ["#{model_name.plural}.non_viewable_post_count ASC", always].compact.join(", "),
      }
    end
  end

  included do
    before_save :refresh_counts

    scope     :viewable, -> { eager.where.not(viewable_post_count: 0) }
    scope :non_viewable, -> { eager.where(    viewable_post_count: 0) }
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
