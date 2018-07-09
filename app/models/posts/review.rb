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
  # CLASS.
  #############################################################################

  def self.eager
    super.includes(:work, :makers, :contributions, :aspects, :milestones)
  end

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :work

  has_many :makers,        through: :work
  has_many :contributions, through: :work
  has_many :contributors,  through: :work
  has_many :aspects,       through: :work
  has_many :milestones,    through: :work

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :work, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # SLUGGABLE.
  #############################################################################

  def sluggable_parts
    work.try(:sluggable_parts) || []
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def medium
    work.try(:true_human_model_name)
  end

  def display_type(plural: false)
    base = [medium, "Review"].compact.join(" ")

    plural ? base.pluralize : base
  end

  def alpha_parts
    work.try(:alpha_parts) || []
  end
end
