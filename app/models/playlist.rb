class Playlist < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_PLAYLISTINGS_AT_ONCE = 20.freeze

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Authorable
  include Alphabetizable

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { includes(:author, :playlistings, :works).references(:author) }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { eager.viewable.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :playlistings, -> { order(:position) }, inverse_of: :playlist, dependent: :destroy

  has_many :works, through: :playlistings

  has_many :creators,     -> { distinct }, through: :works
  has_many :contributors, -> { distinct }, through: :works

  has_many :mixtapes, dependent: :destroy

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :playlistings, allow_destroy: true,
    reject_if: proc { |attrs| attrs["work_id"].blank? }

  def prepare_playlistings
    MAX_PLAYLISTINGS_AT_ONCE.times { self.playlistings.build }
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :title, presence: true

  validates :playlistings, length: { minimum: 2 }

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def all_creators
    Creator.where(id: all_creator_ids)
  end

  def all_creator_ids
    works.map(&:all_creator_ids).flatten.uniq
  end

  def reorder_playlistings!(sorted_playlisting_ids)
    return unless sorted_playlisting_ids.any?

    playlistings = Playlisting.find_by_sorted_ids(sorted_playlisting_ids).where(playlist_id: self.id)

    unless playlistings.length == sorted_playlisting_ids.length && playlistings.length == self.playlistings.count
      raise ArgumentError.new("Bad playlisting reorder; ids don't match.")
    end

    Playlisting.acts_as_list_no_update do
      playlistings.each.with_index(0) { |playlisting, i| playlisting.update!(position: i + 1) }
    end
  end

  def cascade_viewable
    self.update_viewable

    works.each(&:cascade_viewable)
  end

  def sluggable_parts
    [title]
  end

  def alpha_parts
    [title]
  end
end
