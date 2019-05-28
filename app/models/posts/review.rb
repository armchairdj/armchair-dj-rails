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

class Review < Post
  #############################################################################
  # CONCERNING: Image attachment.
  #############################################################################

  concerning :ImageAttachment do
    included do
      delegate :hero_image,        to: :work
      delegate :additional_images, to: :work
    end
  end

  #############################################################################
  # CONCERNING: STI Subclass.
  #############################################################################

  concerning :Subclassed do
    class_methods do
      def for_list
        super.includes(:work).references(:work)
      end

      def for_show
        super.includes(:work, :makers, :contributions, :aspects, :milestones)
      end
    end

    def display_type(plural: false)
      base = [display_medium, "Review"].compact.join(" ")

      plural ? base.pluralize : base
    end
  end

  #############################################################################
  # CONCERNING: Work.
  #############################################################################

  concerning :WorkAssociation do
    included do
      belongs_to :work

      validates :work, presence: true

      has_many :makers,        through: :work
      has_many :contributions, through: :work
      has_many :contributors,  through: :work
      has_many :aspects,       through: :work
      has_many :milestones,    through: :work

      delegate :display_medium, to: :work, allow_nil: true
    end

    def sluggable_parts
      work.try(:sluggable_parts) || []
    end
  end

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  concerning :Alphabetization do
    included do
      include Alphabetizable

      delegate :alpha_parts, to: :work, allow_nil: true
    end
  end
end
