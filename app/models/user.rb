# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  alpha                  :string
#  bio                    :text
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  middle_name            :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("member"), not null
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_alpha                 (alpha)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#


class User < ApplicationRecord

  #############################################################################
  # PLUGINS.
  #############################################################################

  devise(
    :confirmable,
    :database_authenticatable,
    :lockable,
    :recoverable,
    :registerable,
    :rememberable,
    :trackable,
    :validatable
  )

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Linkable

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  include Alphabetizable

  def alpha_parts
    [last_name, first_name, middle_name]
  end

  #############################################################################
  # CONCERNING: Roles.
  #############################################################################

  enum role: {
    member: 10,
    writer: 20,
    editor: 30,
    admin:  40,
    root:   50
  }

  enumable_attributes :role

  validates :role, presence: true

  def can_write?
    root? || admin? || editor? || writer?
  end

  alias_method :can_access_cms?, :can_write?

  def can_edit?
    root? || admin? || editor?
  end

  def can_publish?
    root? || admin?
  end

  alias_method :can_administer?, :can_publish?

  def can_destroy?
    root?
  end

  #############################################################################
  # CONCERNING: Name.
  #############################################################################

  validates :first_name, presence: true
  validates :last_name,  presence: true

  def display_name
    [first_name, middle_name, last_name].compact.join(" ")
  end

  #############################################################################
  # CONCERNING: Username.
  #############################################################################

  validates :username, presence:   true
  validates :username, uniqueness: { case_sensitive: false }
  validates :username, format: { with: /\A[a-zA-Z0-9]+\z/ }

  def to_param
    username
  end

  #############################################################################
  # CONCERNING: Bio.
  #############################################################################

  validates :bio, absence: true, unless: :can_write?

  #############################################################################
  # CONCERNING: Admin access control.
  #############################################################################

  concerning :Editable do
    class_methods do
      def for_cms_user(user)
        return self.none unless user && user.can_administer?
        return self.all  if user.root?

        where("users.role <= ?", user.raw_role).where.not(id: user.id)
      end
    end

    def assignable_role_options
      return [] unless self.can_administer?

      options = self.class.human_roles

      options.slice(0..options.index { |o| o.last == self.role })
    end

    def valid_role_assignment_for?(instance)
      return true if instance.role.blank?
      return true if self.assignable_role_options.map(&:last).include?(instance.role)

      instance.errors.add(:role, :invalid_assignment)

      false
    end
  end

  #############################################################################
  # CONCERNING: Contributing posts and playlists.
  #############################################################################

  concerning :Authoring do
    included do
      scope :published,  -> { joins(:posts).merge(Post.published) }
      scope :for_public, -> { published }

      with_options(dependent: :nullify, foreign_key: "author_id") do |user|
        user.has_many :posts
        user.has_many :articles
        user.has_many :reviews
        user.has_many :mixtapes
        user.has_many :playlists
      end

      has_many :works, through: :reviews
      has_many :makers, -> { distinct }, through: :works
    end

    def published?
      can_write? && posts.published.count > 0
    end
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :for_list, -> { }
  scope :for_show, -> { includes(:links, :posts, :playlists, :works, :makers) }
end
