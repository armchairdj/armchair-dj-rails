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

  concerning :WorkAssociation do
    included do
      belongs_to :work

      has_many :makers,       -> { distinct }, through: :work
      has_many :contributors, -> { distinct }, through: :work

      validates :work, presence: true
    end
  end

  #############################################################################
  # CONCERNING: Posts.
  #############################################################################

  concerning :PostAssociation do
    included do
      has_many :playlists, through: :work
      has_many :mixtapes,  through: :work
      has_many :reviews,   through: :work
    end
  end

  #############################################################################
  # CONCERNING: Activity.
  #############################################################################

  concerning :ActivityAttribute do
    included do
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
    end
  end

  #############################################################################
  # CONCERNING: Year.
  #############################################################################

  concerning :YearAttribute do
    included do
      validates :year, presence: true, yearness: true

      scope :sorted, -> { order(:year) }
    end
  end

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list, -> { sorted }
  scope :for_show, -> { sorted.includes(:work) }
end
