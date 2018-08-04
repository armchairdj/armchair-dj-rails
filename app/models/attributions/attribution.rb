# frozen_string_literal: true

# == Schema Information
#
# Table name: attributions
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  position   :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :bigint(8)
#  role_id    :bigint(8)
#  work_id    :bigint(8)
#
# Indexes
#
#  index_attributions_on_alpha       (alpha)
#  index_attributions_on_creator_id  (creator_id)
#  index_attributions_on_role_id     (role_id)
#  index_attributions_on_work_id     (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => creators.id)
#  fk_rails_...  (role_id => roles.id)
#  fk_rails_...  (work_id => works.id)
#


class Attribution < ApplicationRecord

  #############################################################################
  # CONCERNING: STI subclass contract.
  #############################################################################

  validates :type, presence: true

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  include Alphabetizable

  delegate :alpha_parts, to: :work,    allow_nil: true, prefix: true
  delegate :alpha_parts, to: :creator, allow_nil: true, prefix: true

  def alpha_parts
    [work_alpha_parts, role_name, creator_alpha_parts]
  end

  #############################################################################
  # CONCERNING: Work.
  #############################################################################

  belongs_to :work, inverse_of: :attributions

  validates :work, presence: true

  delegate :display_medium, to: :work, allow_nil: true

  #############################################################################
  # CONCERNING: Creator.
  #############################################################################

  belongs_to :creator, inverse_of: :attributions

  validates :creator, presence: true
end
