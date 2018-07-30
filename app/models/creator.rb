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
  # CONCERNS.
  #############################################################################

  include Booletania

  booletania_columns :primary, :individual

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  concerning :Alpha do
    included do
      include Alphabetizable
    end

    def alpha_parts
      [name]
    end
  end

  #############################################################################
  # CONCERNING: Identities.
  #############################################################################

  concerning :Identities do
    included do
      attribute :primaray, :boolean, default: true

      after_save :enforce_primariness
    end

    def identity_type
      primary? ? "Primary" : "Secondary"
    end

    def personae
      return pseudonyms if primary?

      return self.class.none unless real_name

      aliases   = self.real_name.pseudonyms.where.not(id: self.id)
      real_name = self.class.where(id: self.real_name.id)

      aliases.union_all(real_name).alpha
    end

  private

    def enforce_primariness
      if self.primary?
        self.real_name_identities.clear
      else
        self.pseudonym_identities.clear
      end
    end
  end

  concerning :PseudonymIdentities do
    MAX_PSEUDONYMS_AT_ONCE = 5.freeze

    included do
      ### Scopes.

      scope :primary, -> { where(primary: true) }

      scope :available_pseudonyms, -> {
        secondary.alpha.left_outer_joins(:real_name_identities).
        where(identities: { id: nil })
      }

      ### Associations.

      has_many :pseudonym_identities, foreign_key: :real_name_id,
        inverse_of: :real_name, class_name: "Identity", dependent: :destroy

      has_many :pseudonyms, -> { order("creators.name") },
        through: :pseudonym_identities, source: :pseudonym

      ### Attributes.

      accepts_nested_attributes_for(:pseudonym_identities,
        allow_destroy: true, reject_if: :invalid_pseudonym_attrs?
      )
    end

    def prepare_pseudonym_identities
      MAX_PSEUDONYMS_AT_ONCE.times { self.pseudonym_identities.build }
    end

    def available_pseudonyms
      self.class.available_pseudonyms.union(self.pseudonyms).alpha
    end

  private

    def invalid_pseudonym_attrs?(attrs)
      key = attrs["pseudonym_id"]

      return true if key.blank?
      return true if self.class.find(key).primary?

      false
    end
  end

  concerning :RealNameIdentities do
    MAX_REAL_NAMES = 1.freeze

    included do
      ### Scopes.

      scope :secondary, -> { where(primary: false) }

      scope :available_real_names, -> { primary.alpha }

      ### Associations.

      has_many :real_name_identities, foreign_key: :pseudonym_id,
        inverse_of: :pseudonym, class_name: "Identity", dependent: :destroy

      has_many :real_names, -> { order("creators.name") },
        through: :real_name_identities, source: :real_name

      ### Attributes.

      accepts_nested_attributes_for(:real_name_identities,
        allow_destroy: true, reject_if: :invalid_real_name_attrs?
      )
    end

    def prepare_real_name_identities
      count_needed = MAX_REAL_NAMES - self.real_name_identities.length

      count_needed.times { self.real_name_identities.build }
    end

    def secondary?
      !primary?
    end

    alias_method :pseudonym?, :secondary?

    def real_name
      real_names.first
    end

  private

    def invalid_real_name_attrs?(attrs)
      key = attrs["real_name_id"]

      return true if key.blank?
      return true if self.class.find(key).secondary?

      false
    end
  end

  #############################################################################
  # CONCERNING: Memberships.
  #############################################################################

  concerning :Memberships do
    included do
      attribute :individual, :boolean, default: true

      after_save :enforce_individuality
    end

    def membership_type
      individual? ? "Individual" : "Group"
    end

    def colleagues
      return self.class.none unless individual? && groups.any?

      ids = groups.map(&:members).to_a.flatten.pluck(:id).reject { |id| id == self.id }.uniq

      Creator.where(id: ids).alpha
    end

  private

    def enforce_individuality
      if self.collective?
        self.group_memberships.clear
      else
        self.member_memberships.clear
      end
    end
  end

  concerning :GroupMemberships do
    MAX_GROUPS_AT_ONCE  = 5.freeze

    included do
      ### Scopes.

      scope :individual, -> { where(individual: true) }

      scope :available_groups,  -> { collective.alpha }

      ### Associations.

      has_many :group_memberships, foreign_key: :member_id,
        inverse_of: :member, class_name: "Membership", dependent: :destroy

      has_many :groups, -> { order("creators.name") },
        through: :group_memberships,  source: :group

      ### Attributes.

      accepts_nested_attributes_for(:group_memberships,
        allow_destroy: true, reject_if: :invalid_group_attributes?
      )
    end

    def prepare_group_memberships
      MAX_GROUPS_AT_ONCE.times { self.group_memberships.build }
    end

  private

    def invalid_group_attributes?(attrs)
      key = attrs["group_id"]

      return true if key.blank?
      return true if self.class.find(key).individual?

      false
    end
  end

  concerning :MemberMemberships do
    MAX_MEMBERS_AT_ONCE = 5.freeze

    included do
      ### Scopes.

      scope :collective, -> { where(individual: false) }

      scope :available_members, -> { individual.alpha }

      ### Associations.

      has_many :member_memberships, foreign_key: :group_id,
        inverse_of: :group, class_name: "Membership", dependent: :destroy

      has_many :members, -> { order("creators.name") },
        through: :member_memberships, source: :member

      ### Attributes.

      accepts_nested_attributes_for(:member_memberships,
        allow_destroy: true, reject_if: :invalid_member_attributes?
      )
    end

    def prepare_member_memberships
      MAX_MEMBERS_AT_ONCE.times { self.member_memberships.build }
    end

    def collective?
      !individual?
    end

    alias_method :group?, :collective?

  private

    def invalid_member_attributes?(attrs)
      key = attrs["member_id"]

      return true if key.blank?
      return true if self.class.find(key).collective?

      false
    end
  end

  #############################################################################
  # SCOPES.
  #############################################################################

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

  has_many :works,   through: :credits
  has_many :reviews, through: :works

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

  #############################################################################
  # ATTRIBUTES
  #############################################################################

  def prepare_for_editing
    prepare_pseudonym_identities
    prepare_real_name_identities
    prepare_member_memberships
    prepare_group_memberships
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true

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
end
