# frozen_string_literal: true

# == Schema Information
#
# Table name: contributions
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :bigint(8)
#  role_id    :bigint(8)
#  work_id    :bigint(8)
#
# Indexes
#
#  index_contributions_on_alpha       (alpha)
#  index_contributions_on_creator_id  (creator_id)
#  index_contributions_on_role_id     (role_id)
#  index_contributions_on_work_id     (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#


class Contribution < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable
  include Contributable

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :role

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  delegate :name, to: :role

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :role_id, presence: true
  validates :role_id, inclusion: { allow_blank: true, in: proc { |record| record.work.try(:available_role_ids) || [] } }

  validates :creator_id, uniqueness: { scope: [:work_id, :role_id] }

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def alpha_parts
    [work.try(:alpha_parts), role.try(:name), creator.try(:name)]
  end
end
