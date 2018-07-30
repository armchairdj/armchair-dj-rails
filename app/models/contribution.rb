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
  # CONCERNS.
  #############################################################################

  include Contributable

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :for_list,  -> { }
  scope :for_show,  -> { includes(:work, :creator, :role) }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :role

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :role_id, presence: true
  validates :role_id, inclusion: { allow_blank: true, in:
    proc { |record| record.work.try(:available_role_ids) || [] }
  }

  validates :creator_id, uniqueness: { scope: [:work_id, :role_id] }

  #############################################################################
  # INSTANCE.
  #############################################################################

  def role_name
    role.try(:name)
  end
end
