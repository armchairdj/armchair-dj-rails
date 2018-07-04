# == Schema Information
#
# Table name: milestones
#
#  id         :bigint(8)        not null, primary key
#  activity   :integer          not null
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  work_id    :bigint(8)
#
# Indexes
#
#  index_milestones_on_activity  (activity)
#  index_milestones_on_work_id   (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#

class Milestone < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :sorted,    -> { order(:year) }
  scope :eager,     -> { includes(:work) }
  scope :for_admin, -> { eager }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :work

  has_many :creators,     -> { distinct }, through: :work
  has_many :contributors, -> { distinct }, through: :work

  has_many :playlists, through: :work
  has_many :mixtapes,  through: :work
  has_many :reviews,   through: :work

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  enum activity: {
    released:    0,
    published:   1,
    aired:       2,

    created:    10,

    reissued:   20,
    rereleased: 21,
    remastered: 22,
    recut:      23,
    remixed:    24
  }

  enumable_attributes :activity

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :work, presence: true

  validates :activity, presence: true
  validates :activity, uniqueness: { scope: [:work_id] }

  validates :year, presence: true, yearness: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def posts
    reviews.union(mixtapes)
  end
end
