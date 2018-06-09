# frozen_string_literal: true

class Mixtape < Post

  #############################################################################
  # CONCERNS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { includes(:author, :tags, :playlist, :playlistings, :works, :creators) }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { eager.published.reverse_cron }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :playlist

  has_many :playlistings, through: :playlist
  has_many :works,        through: :playlistings

  has_many :media,         through: :works
  has_many :creators,      through: :works
  has_many :contributors,  through: :works
  has_many :work_tags,     through: :works, class_name: "Tag", source: :tags

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :playlist, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # SLUGGABLE.
  #############################################################################

  def sluggable_parts
    playlist.try(:sluggable_parts) || []
  end

  #############################################################################
  # INSTANCE: TYPE METHODS.
  #############################################################################

  def type(plural: false)
    plural ? "Mixtapes" : "Mixtape"
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def all_tags
    Tag.where(id: [self.tag_ids, self.work_tags.map(&:id)].flatten.uniq)
  end

  def alpha_parts
    playlist.try(:alpha_parts) || []
  end

  def cascade_viewable
    super

    playlist.cascade_viewable
  end
end
