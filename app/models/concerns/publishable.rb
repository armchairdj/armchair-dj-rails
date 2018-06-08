# frozen_string_literal: true

module Publishable
  extend ActiveSupport::Concern

  #############################################################################
  # CLASS.
  #############################################################################

  class_methods do
    def publish_scheduled
      ready = self.scheduled_ready

      memo = {
        total:   ready.length,
        success: [],
        failure: []
      }

      ready.each do |instance|
        instance.unschedule!

        if instance.publish!
          memo[:success] << instance
        else
          memo[:failure] << instance
        end
      end

      memo
    end
  end

  #############################################################################
  # INCLUDED.
  #############################################################################

  included do

    ###########################################################################
    # CONCERNS.
    ###########################################################################

    include AASM
    include Authorable

    ###########################################################################
    # SCOPES.
    ###########################################################################

    scope :unpublished,     -> { where.not(status: :published) }
    scope :scheduled_ready, -> { scheduled.where("#{model_name.collection}.publish_on <= ?", DateTime.now) }
    scope :reverse_cron,    -> { order(published_at: :desc, publish_on: :desc, updated_at: :desc) }

    #############################################################################
    # ASSOCIATIONS.
    #############################################################################

    has_and_belongs_to_many :tags

    #############################################################################
    # ATTRIBUTES.
    #############################################################################

    enum status: {
      draft:      0,
      scheduled:  5,
      published: 10
    }

    enumable_attributes :status

    ###########################################################################
    # VALIDATION.
    ###########################################################################

    validates :body, presence: true, unless: :draft?

    validates :status, presence: true

    validates :published_at, presence: true, if: :published?
    validates :publish_on,   presence: true, if: :scheduled?

    validates_date :publish_on, :after => lambda { Date.current }, allow_blank: true

    validate { only_bare_tags }

    def only_bare_tags
      return if tags.where.not(category_id: nil).empty?

      self.errors.add(:tag_ids, :has_categorized_tags)
    end

    private :only_bare_tags

    ###########################################################################
    # AASM.
    ###########################################################################

    aasm(
      column:                   :status,
      create_scopes:            true,
      enum:                     true,
      no_direct_assignment:     true,
      whiny_persistence:        false,
      whiny_transitions:        false
    ) do
      state :draft, initial: true
      state :scheduled
      state :published

      event(:schedule,
        after: [:update_viewable_for_publishable, :update_viewable_for_all]
      ) do
        transitions from: :draft, to: :scheduled, guards: [:ready_to_publish?]
      end

      event(:unschedule,
        before: :clear_publish_on,
        after:  [:update_viewable_for_publishable, :update_viewable_for_all]
      ) do
        transitions from: :scheduled, to: :draft
      end

      event(:publish,
        before: :set_published_at,
        after:  [:update_viewable_for_publishable, :update_viewable_for_all]
      ) do
        transitions from: [:draft, :scheduled], to: :published, guards: [:ready_to_publish?]
      end

      event(:unpublish,
        before: :clear_published_at,
        after:  [:update_viewable_for_publishable, :update_viewable_for_all]
      ) do
        transitions from: :published, to: :draft
      end
    end
  end

  #############################################################################
  # TRANSITIONS.
  #############################################################################

  def update_and_publish(params)
    return true if self.update(params) && self.publish!

    self.errors.add(:body, :blank_during_publish) unless body.present?

    return false
  end

  def update_and_unpublish(params)
    # Transition and reload to trigger validation changes before update.
    unpublished = self.unpublish!
    updated     = self.reload.update(params)

    unpublished && updated
  end

  def update_and_schedule(params)
    return true if self.update(params) && self.schedule!

    clear_publish_on_from_database

    self.errors.add(:body, :blank_during_publish) unless body.present?

    return false
  end

  def update_and_unschedule(params)
    # Transition and reload to trigger validation changes before update.
    unscheduled = self.unschedule!
    updated     = self.reload.update(params)

    unscheduled && updated
  end

  #############################################################################
  # SLUGGABLE.
  #############################################################################

  def slug_locked?
    published?
  end

  def validate_slug_presence?
    !draft?
  end

  private :validate_slug_presence?

  #############################################################################
  # INSTANCE.
  #############################################################################

  def viewable?
    published?
  end

  def unpublished?
    draft? || scheduled?
  end

  def update_viewable_for_all
    raise NotImplementedError
  end

private

  #############################################################################
  # AASM CALLBACKS.
  #############################################################################

  def ready_to_publish?
    persisted? && unpublished? && valid? && body.present?
  end

  def set_published_at
    self.published_at = DateTime.now
  end

  def clear_published_at
    self.published_at = nil
  end

  def clear_publish_on
    self.publish_on = nil
  end

  def clear_publish_on_from_database
    return unless temp = self.publish_on

    self.update_column(:publish_on, nil)

    self.publish_on = temp
  end

  def update_viewable_for_publishable
    author.update_viewable

    tags.each { |t| t.update_viewable }
  end
end
