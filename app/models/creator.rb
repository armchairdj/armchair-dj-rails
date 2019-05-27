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
  # CONCERNING: Name.
  #############################################################################

  concerning :NameAttribute do
    included do
      validates :name, presence: true
    end
  end

  #############################################################################
  # CONCERNING: Primariness & Identities
  #############################################################################

  concerning :PrimaryAttribute do
    included do
      attribute :primary, :boolean, default: true

      scope :primary,   -> { where(primary: true) }
      scope :secondary, -> { where(primary: false) }

      after_save :enforce_primariness
    end

    def identity_type
      primary? ? "Primary" : "Secondary"
    end

    def personae
      return pseudonyms if primary?

      return self.class.none unless real_name

      aliases   = real_name.pseudonyms.where.not(id: id)
      real_name = self.class.where(id: self.real_name.id)

      aliases.union_all(real_name).alpha
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def enforce_primariness
      if primary?
        real_name_identities.clear
      else
        pseudonym_identities.clear
      end
    end
  end

  concerning :PseudonymAssociations do
    included do
      has_many :pseudonym_identities, class_name: "Creator::Identity",
        foreign_key: :real_name_id, inverse_of: :real_name, dependent: :destroy

      has_many :pseudonyms, -> { order("creators.name") },
               through: :pseudonym_identities, source: :pseudonym

      scope :available_pseudonyms, lambda {
        secondary.alpha.left_outer_joins(:real_name_identities)
                 .where(creator_identities: { id: nil })
      }

      accepts_nested_attributes_for(:pseudonym_identities,
                                    allow_destroy: true, reject_if: :reject_pseudonym_identity?)
    end

    def prepare_pseudonym_identities
      5.times { pseudonym_identities.build }
    end

    def available_pseudonyms
      self.class.available_pseudonyms.union(pseudonyms).alpha
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def reject_pseudonym_identity?(attrs)
      key = attrs["pseudonym_id"]

      return true if key.blank?
      return true if self.class.find(key).primary?

      false
    end
  end

  concerning :RealNameAssociation do
    included do
      has_many :real_name_identities, class_name: "Creator::Identity",
        foreign_key: :pseudonym_id, inverse_of: :pseudonym, dependent: :destroy

      has_many :real_names, -> { order("creators.name") },
               through: :real_name_identities, source: :real_name

      scope :available_real_names, -> { primary.alpha }

      accepts_nested_attributes_for(:real_name_identities,
                                    allow_destroy: true, reject_if: :reject_real_name_identity?)

      alias_method :pseudonym?, :secondary?
    end

    def prepare_real_name_identities
      count_needed = 1 - real_name_identities.length

      count_needed.times { real_name_identities.build }
    end

    def secondary?
      !primary?
    end

    def real_name
      real_names.first
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def reject_real_name_identity?(attrs)
      key = attrs["real_name_id"]

      return true if key.blank?
      return true if self.class.find(key).secondary?

      false
    end
  end

  #############################################################################
  # CONCERNING: Individuality & Memberships.
  #############################################################################

  concerning :IndividualAttribute do
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

    private # rubocop:disable Lint/UselessAccessModifier

    def enforce_individuality
      if collective?
        group_memberships.clear
      else
        member_memberships.clear
      end
    end
  end

  concerning :GroupAssociations do
    included do
      has_many :group_memberships, class_name: "Creator::Membership",
        foreign_key: :member_id, inverse_of: :member, dependent: :destroy

      has_many :groups, -> { order("creators.name") },
               through: :group_memberships, source: :group

      scope :individual, -> { where(individual: true) }

      scope :available_groups, -> { collective.alpha }

      accepts_nested_attributes_for(:group_memberships,
                                    allow_destroy: true, reject_if: :reject_group_membership?)
    end

    def prepare_group_memberships
      5.times { group_memberships.build }
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def reject_group_membership?(attrs)
      key = attrs["group_id"]

      return true if key.blank?
      return true if self.class.find(key).individual?

      false
    end
  end

  concerning :MemberAssociations do
    included do
      has_many :member_memberships, class_name: "Creator::Membership",
        foreign_key: :group_id, inverse_of: :group, dependent: :destroy

      has_many :members, -> { order("creators.name") },
               through: :member_memberships, source: :member

      scope :collective, -> { where(individual: false) }

      scope :available_members, -> { individual.alpha }

      accepts_nested_attributes_for(:member_memberships,
                                    allow_destroy: true, reject_if: :reject_member_membership?)

      alias_method :group?, :collective?
    end

    def prepare_member_memberships
      5.times { member_memberships.build }
    end

    def collective?
      !individual?
    end

    private # rubocop:disable Lint/UselessAccessModifier

    def reject_member_membership?(attrs)
      key = attrs["member_id"]

      return true if key.blank?
      return true if self.class.find(key).collective?

      false
    end
  end

  #############################################################################
  # CONCERNING: Attributions, credits & contributions.
  #############################################################################

  concerning :AttributionAssociations do
    included do
      has_many :attributions,  inverse_of: :creator, dependent: :destroy
      has_many :credits,       inverse_of: :creator, dependent: :destroy
      has_many :contributions, inverse_of: :creator, dependent: :destroy
    end

    def works
      Work.where(id: attributions.select(:work_id).distinct)
    end

    def display_roles
      raw = attributions.includes(:work, :role).to_a.group_by(&:display_medium)

      raw.transform_values! { |v| v.map(&:role_name).uniq.sort }
    end
  end

  concerning :CreditedAssociations do
    included do
      has_many :credited_works, -> { distinct }, through: :credits,
        class_name: "Work", source: :work

      has_many :credited_playlistings, -> { distinct }, through: :credited_works,
        class_name: "Playlist::Track", source: :playlistings

      has_many :credited_playlists, -> { distinct }, through: :credited_playlistings,
        class_name: "Playlist", source: :playlist
    end
  end

  concerning :ContributedAssociations do
    included do
      has_many :contributed_works, -> { distinct }, through: :contributions,
        class_name: "Work", source: :work

      has_many :contributed_playlistings, -> { distinct }, through: :contributed_works,
        class_name: "Playlist::Track", source: :playlistings

      has_many :contributed_playlists, -> { distinct }, through: :contributed_playlistings,
        class_name: "Playlist", source: :playlist

      has_many :contributed_roles, -> { includes(contributions: :work) },
               through: :contributions, class_name: "Role", source: :role
    end
  end

  #############################################################################
  # CONCERNING: Posts.
  #############################################################################

  concerning :PostAssociations do
    included do
      has_many :credited_reviews, -> { distinct }, through: :credited_works,
        class_name: "Review", source: :reviews

      has_many :contributed_reviews, -> { distinct }, through: :contributed_works,
        class_name: "Review", source: :reviews

      has_many :credited_mixtapes, -> { distinct }, through: :credited_playlists,
        class_name: "Mixtape", source: :mixtapes

      has_many :contributed_mixtapes, -> { distinct }, through: :contributed_playlists,
        class_name: "Mixtape", source: :mixtapes
    end

    def post_ids
      (contributed_mixtapes.ids +
          credited_mixtapes.ids +
        contributed_reviews.ids +
           credited_reviews.ids).uniq
    end

    def posts
      Post.where(id: post_ids)
    end
  end

  #############################################################################
  # CONCERNING: Editing.
  #############################################################################

  include Booletania

  concerning :Editing do
    included do
      booletania_columns :primary, :individual
    end

    def prepare_for_editing
      prepare_pseudonym_identities
      prepare_real_name_identities
      prepare_member_memberships
      prepare_group_memberships
    end
  end

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list,  -> {}
  scope :for_show,  lambda {
                      includes(
                        :pseudonyms, :real_names,
                        :members,           :groups,
                        :credits,           :contributions,
                        :credited_works,    :contributed_works,
                        :credited_reviews,  :contributed_reviews,
                        :credited_mixtapes, :contributed_mixtapes,
                        :contributed_roles
                      )
                    }

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  include Alphabetizable

  concerning :Alphabetization do
    def alpha_parts
      [name]
    end
  end
end
