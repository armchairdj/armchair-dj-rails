module Viewable
  extend ActiveSupport::Concern

  included do
    before_save :update_counts

    scope     :viewable, -> { where.not(viewable_post_count: 0) }
    scope :non_viewable, -> {     where(viewable_post_count: 0) }
  end

  class_methods do
    def admin_scopes
      {
        'Viewable'     => :viewable,
        'Non-Viewable' => :non_viewable,
        'All'          => :all
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
    self.posts.draft.reverse_cron
  end

  def viewable_works
    self.viewable_posts.map(&:work).uniq
  end

  def non_viewable_works
    self.non_viewable_posts.map(&:work).uniq
  end

private

  def update_counts
        self.viewable_post_count = self.posts.published.count
    self.non_viewable_post_count = self.posts.draft.count
  end
end
