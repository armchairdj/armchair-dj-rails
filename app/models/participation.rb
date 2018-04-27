# frozen_string_literal: true

class Participation < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MIRRORS = {
      named: :has_name,
      has_name: :named,
     member_of: :has_member,
    has_member: :member_of
  }.freeze

  #############################################################################
  # CONCERNS.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :creator,     required: true
  belongs_to :participant, required: true, class_name: "Creator"

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  enum relationship: {
    named:         10,
    has_name:      11,

    member_of:     20,
    has_member:    21
  }

  enumable_attributes :relationship

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :creator,      presence: true
  validates :participant,  presence: true
  validates :relationship, presence: true

  validates :creator_id, uniqueness: { scope: [:relationship, :participant_id] }

  #############################################################################
  # HOOKS.
  #############################################################################

  after_create :create_mirror, unless: :do_not_mirror?

  attr_accessor :do_not_mirror

  #############################################################################
  # INSTANCE.
  #############################################################################

private

  def do_not_mirror?
    self.do_not_mirror == true
  end

  def create_mirror
    return unless mirror = MIRRORS.public_send(:[], relationship.to_sym)

    mirrored = self.class.find_or_initialize_by({
      creator:       participant,
      participant:   creator,
      relationship:  mirror
    })

    return if mirrored.persisted?

    mirrored.do_not_mirror = true

    mirrored.save!
  end
end
