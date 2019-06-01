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
  concerning :ImageAttachment do
    included do
      delegate :hero_image,        to: :playlist
      delegate :additional_images, to: :playlist
    end
  end

  concerning :Subclassed do
    class_methods do
      def for_list
        super.includes(:playlist).references(:playlist)
      end

      def for_show
        super.includes(:playlist, :tracks, :works, :makers, :contributions, :aspects, :milestones)
      end
    end

    def display_type(plural: false)
      plural ? "Mixtapes" : "Mixtape"
    end
  end

  concerning :PlaylistAssociation do
    included do
      belongs_to :playlist

      validates :playlist, presence: true

      has_many :tracks, through: :playlist
      has_many :works,  through: :tracks

      has_many :makers,        through: :works
      has_many :contributions, through: :works
      has_many :contributors,  through: :works
      has_many :aspects,       through: :works
      has_many :milestones,    through: :works
    end

    def sluggable_parts
      [playlist&.title]
    end
  end

  concerning :Alphabetization do
    included do
      include Alphabetizable

      delegate :alpha_parts, to: :playlist, allow_nil: true
    end
  end
end
