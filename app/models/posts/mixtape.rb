# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :bigint(8)        not null, primary key
#  alpha        :string
#  body         :text
#  publish_on   :datetime
#  published_at :datetime
#  slug         :string
#  status       :integer          default("draft"), not null
#  summary      :text
#  title        :string
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :bigint(8)
#  playlist_id  :bigint(8)
#  work_id      :bigint(8)
#
# Indexes
#
#  index_posts_on_alpha        (alpha)
#  index_posts_on_author_id    (author_id)
#  index_posts_on_playlist_id  (playlist_id)
#  index_posts_on_slug         (slug) UNIQUE
#  index_posts_on_status       (status)
#  index_posts_on_type         (type)
#  index_posts_on_work_id      (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (playlist_id => playlists.id)
#  fk_rails_...  (work_id => works.id)
#


class Mixtape < Post

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  delegate :alpha_parts, to: :playlist, allow_nil: true

  #############################################################################
  # CONCERNING: STI Subclassed.
  #############################################################################

  concerning :Subclassing do
    class_methods do
      def for_list
        super.includes(:playlist).references(:playlist)
      end

      def for_show
        super.includes(:playlist, :tracks, :works, :makers, :contributions, :aspects, :milestones)
      end
    end
  end

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :playlist

  has_many :tracks, through: :playlist
  has_many :works,  through: :tracks

  has_many :makers,        through: :works
  has_many :contributions, through: :works
  has_many :contributors,  through: :works
  has_many :aspects,       through: :works
  has_many :milestones,    through: :works

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :playlist, presence: true

  #############################################################################
  # INSTANCE.
  #############################################################################

  def sluggable_parts
    [ playlist.try(:title) ]
  end

  def display_type(plural: false)
    plural ? "Mixtapes" : "Mixtape"
  end
end
