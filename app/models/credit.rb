# frozen_string_literal: true
# == Schema Information
#
# Table name: credits
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :bigint(8)
#  work_id    :bigint(8)
#
# Indexes
#
#  index_credits_on_alpha       (alpha)
#  index_credits_on_creator_id  (creator_id)
#  index_credits_on_work_id     (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => creators.id)
#  fk_rails_...  (work_id => works.id)
#

class Credit < ApplicationRecord

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Contributable
  include Listable

  acts_as_listable(:work)

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :for_list,  -> { }
  scope :for_show,  -> { includes(:work, :creator) }

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :creator_id, uniqueness: { scope: [:work_id] }

  #############################################################################
  # INSTANCE.
  #############################################################################

  def role_name
    "Creator"
  end
end
