module PubliclyViewable
  extend ActiveSupport::Concern

  def is_public?
    self.published_posts.any?
  end

  def published_posts
    self.posts.published.reverse_cron
  end
end
