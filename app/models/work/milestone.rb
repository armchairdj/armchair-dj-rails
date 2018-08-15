# == Schema Information
#
# Table name: work_milestones
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
#  index_work_milestones_on_activity  (activity)
#  index_work_milestones_on_work_id   (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#

class Work::Milestone < ApplicationRecord
  self.table_name = "work_milestones"

  #############################################################################
  # CONCERNING: Work.
  #############################################################################

  belongs_to :work

  has_many :makers,       -> { distinct }, through: :work
  has_many :contributors, -> { distinct }, through: :work

  validates :work, presence: true

  #############################################################################
  # CONCERNING: Activity.
  #############################################################################

  validates :activity, presence: true
  validates :activity, uniqueness: { scope: [:work_id] }

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

  improve_enum :activity

  #############################################################################
  # CONCERNING: Year.
  #############################################################################

  validates :year, presence: true, yearness: true

  scope :sorted, -> { order(:year) }

  #############################################################################
  # CONCERNING: Posts.
  #############################################################################

  has_many :playlists, through: :work
  has_many :mixtapes,  through: :work
  has_many :reviews,   through: :work

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list, -> { sorted }
  scope :for_show, -> { sorted.includes(:work) }
end
