# frozen_string_literal: true

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

class Work
  class Milestone < ApplicationRecord
    self.table_name = "work_milestones"

    concerning :WorkAssociation do
      included do
        belongs_to :work

        has_many :makers,       -> { distinct }, through: :work
        has_many :contributors, -> { distinct }, through: :work

        validates :work, presence: true
      end
    end

    concerning :PostAssociation do
      included do
        has_many :playlists, through: :work
        has_many :mixtapes,  through: :work
        has_many :reviews,   through: :work
      end
    end

    concerning :ActivityAttribute do
      included do
        validates :activity, presence: true
        validates :activity, uniqueness: { scope: [:work_id] }

        enum activity: {
          released:   0,
          published:  1,
          aired:      2,

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

    concerning :YearAttribute do
      included do
        validates :year, presence: true, yearness: true

        scope :sorted, -> { order(:year) }
      end
    end

    concerning :GinsuIntegration do
      included do
        scope :for_list, -> { sorted }
        scope :for_show, -> { sorted.includes(:work) }
      end
    end
  end
end
