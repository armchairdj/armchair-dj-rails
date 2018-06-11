# frozen_string_literal: true

module Viewable
  extend ActiveSupport::Concern

  #############################################################################
  # SCOPES.
  #############################################################################

  included do
    scope   :viewable, -> { eager.where(viewable: true ) }
    scope :unviewable, -> { eager.where(viewable: false) }

    before_save :refresh_viewable
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def unviewable?
    !viewable?
  end

  def update_viewable
    refresh_viewable && save
  end

private

  def refresh_viewable
    self.viewable = has_published_content?

    viewable_changed?
  end

  def has_published_content?
    has_published_posts?
  end

  def has_published_posts?
    return true if respond_to?(:posts   ) &&    posts.published.count > 0
    return true if respond_to?(:articles) && articles.published.count > 0
    return true if respond_to?(:reviews ) &&  reviews.published.count > 0
    return true if respond_to?(:mixtapes) && mixtapes.published.count > 0

    false
  end
end
