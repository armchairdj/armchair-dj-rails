# frozen_string_literal: true

# == Schema Information
#
# Table name: creators
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  individual :boolean          default(TRUE), not null
#  name       :string           not null
#  primary    :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_creators_on_alpha       (alpha)
#  index_creators_on_individual  (individual)
#  index_creators_on_primary     (primary)
#


require "wannabe_bool"

class Creator < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_PSEUDONYMS_AT_ONCE  = 5.freeze
  MAX_REAL_NAMES          = 1.freeze

  MAX_MEMBERS_AT_ONCE     = 5.freeze
  MAX_GROUPS_AT_ONCE      = 5.freeze

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable

  include Booletania

  booletania_columns :primary, :individual

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :primary,    -> { where(primary:     true) }
  scope :secondary,  -> { where(primary:    false) }
  scope :individual, -> { where(individual:  true) }
  scope :collective, -> { where(individual: false) }

  scope :orphaned, -> { left_outer_joins(:real_name_identities).where(identities: { id: nil } ) }

  scope :available_groups,     -> { alpha.collective         }
  scope :available_members,    -> { alpha.individual         }
  scope :available_real_names, -> { alpha.primary            }
  scope :available_pseudonyms, -> { alpha.secondary.orphaned }

  scope :for_list,  -> { }
  scope :for_show,  -> { includes(
    :pseudonyms, :real_names, :members, :groups,
    :credits, :contributed_roles,
    :works, :contributed_works,
    :reviews, :contributed_reviews,
    :mixtapes, :contributed_mixtapes,
  ) }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  # Credits.

  has_many :credits, inverse_of: :creator, dependent: :destroy

  has_many :works,        through: :credits

  has_many :reviews,      through: :works

  has_many :playlistings, -> { distinct }, through: :works

  has_many :playlists,    -> { distinct }, through: :playlistings

  has_many :mixtapes,     -> { distinct }, through: :playlists

  # Contributions.

  has_many :contributions, inverse_of: :creator, dependent: :destroy

  has_many :contributed_roles, -> { includes(contributions: :work) },
    through: :contributions, class_name: "Role", source: :role

  has_many :contributed_works, -> { distinct }, through: :contributions,
    class_name: "Work", source: :work

  has_many :contributed_reviews, through: :contributed_works,
    class_name: "Review", source: :reviews

  has_many :contributed_playlistings, -> { distinct }, through: :contributed_works,
    class_name: "Playlisting", source: :playlistings

  has_many :contributed_playlists, -> { distinct }, through: :contributed_playlistings,
    class_name: "Playlist", source: :playlist

  has_many :contributed_mixtapes, -> { distinct }, through: :contributed_playlists,
    class_name: "Mixtape", source: :mixtapes

  # Identities.

  has_many :pseudonym_identities, class_name: "Identity", dependent: :destroy,
    foreign_key: :real_name_id, inverse_of: :real_name

  has_many :real_name_identities, class_name: "Identity", dependent: :destroy,
    foreign_key: :pseudonym_id, inverse_of: :pseudonym

  has_many :pseudonyms, -> { order("creators.name") },
    through: :pseudonym_identities, source: :pseudonym

  has_many :real_names, -> { order("creators.name") },
    through: :real_name_identities, source: :real_name

  # Memberships.

  has_many :member_memberships, class_name: "Membership", dependent: :destroy,
    foreign_key: :group_id, inverse_of: :group

  has_many :group_memberships,  class_name: "Membership", dependent: :destroy,
    foreign_key: :member_id, inverse_of: :member

  has_many :members, -> { order("creators.name") },
    through: :member_memberships, source: :member

  has_many  :groups, -> { order("creators.name") },
    through: :group_memberships,  source: :group

  #############################################################################
  # ATTRIBUTES: pseudonym_identities
  #############################################################################

  accepts_nested_attributes_for :pseudonym_identities, allow_destroy: true,
    reject_if: :blank_or_primary?

  def blank_or_primary?(attrs)
    key = attrs["pseudonym_id"]

    return true if key.blank?
    return true if self.class.find(key).primary?
  end

  private :blank_or_primary?

  def prepare_pseudonym_identities
    MAX_PSEUDONYMS_AT_ONCE.times { self.pseudonym_identities.build }
  end

  def available_pseudonyms
    self.class.available_pseudonyms.union(self.pseudonyms).alpha
  end

  #############################################################################
  # ATTRIBUTES: real_name_identities
  #############################################################################

  accepts_nested_attributes_for :real_name_identities, allow_destroy: true,
    reject_if: :blank_or_secondary?

  def blank_or_secondary?(attrs)
    key = attrs["real_name_id"]

    return true if key.blank?
    return true if self.class.find(key).secondary?
  end

  private :blank_or_secondary?

  def prepare_real_name_identities
    count_needed = MAX_REAL_NAMES - self.real_name_identities.length

    count_needed.times { self.real_name_identities.build }
  end

  def group?
    !individual?
  end

  def secondary?
    !primary?
  end

  alias_method :alias?, :secondary?

  def real_name
    real_names.first
  end

  def personae
    return pseudonyms if primary?

    return self.class.none unless real_name

    aliases = real_name.pseudonyms.where.not(id: self.id)
    parent  = self.class.where(id: real_name.id)

    aliases.union_all(parent).alpha
  end

  #############################################################################
  # ATTRIBUTES: member_memberships
  #############################################################################

  accepts_nested_attributes_for :member_memberships, allow_destroy: true,
    reject_if: :blank_or_collective?

  def blank_or_collective?(attrs)
    key = attrs["member_id"]

    return true if key.blank?
    return true if self.class.find(key).collective?
  end

  private :blank_or_collective?

  def prepare_member_memberships
    MAX_MEMBERS_AT_ONCE.times { self.member_memberships.build }
  end

  #############################################################################
  # ATTRIBUTES: group_memberships
  #############################################################################

  accepts_nested_attributes_for :group_memberships, allow_destroy: true,
    reject_if: :blank_or_individual?

  def blank_or_individual?(attrs)
    key = attrs["group_id"]

    return true if key.blank?
    return true if self.class.find(key).individual?
  end

  private :blank_or_individual?

  def prepare_group_memberships
    MAX_GROUPS_AT_ONCE.times { self.group_memberships.build }
  end

  def collective?
    !individual?
  end

  def colleagues
    return self.class.none unless individual? && groups.any?

    ids = groups.map(&:members).to_a.flatten.pluck(:id).reject { |id| id == self.id }.uniq

    Creator.where(id: ids).alpha
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name,       presence: true
  # validates :primary,    presence: true
  # validates :individual, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  def enforce_primariness
    if self.primary?
      self.real_name_identities.destroy_all
    else
      self.pseudonym_identities.destroy_all
    end
  end

  after_save :enforce_primariness

  private :enforce_primariness

  def enforce_individuality
    if self.collective?
      self.group_memberships.destroy_all
    else
      self.member_memberships.destroy_all
    end
  end

  after_save :enforce_individuality

  private :enforce_individuality

  #############################################################################
  # INSTANCE.
  #############################################################################

  def all_works
    works.union(contributed_works).alpha
  end

  def posts
    Post.where(id: post_ids)
  end

  def post_ids
    (reviews.ids + contributed_reviews.ids + mixtapes.ids + contributed_mixtapes.ids).uniq
  end

  def display_roles
    cred =       credits.includes(:work       )
    cont = contributions.includes(:work, :role)

    all = (cred.to_a + cont.to_a).group_by(&:display_medium)

    all.transform_values! { |v| v.map(&:role_name).uniq.sort }
  end

  def alpha_parts
    [name]
  end
end
