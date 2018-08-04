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

class Contribution < Attribution

  #############################################################################
  # CONCERNING: Work.
  #############################################################################

  belongs_to :work, inverse_of: :contributions

  #############################################################################
  # CONCERNING: Creator.
  #############################################################################

  belongs_to :creator, inverse_of: :contributions

  validates :creator_id, uniqueness: { scope: [:work_id, :role_id] }

  #############################################################################
  # Concerning: Role.
  #############################################################################

  belongs_to :role

  validates :role_id, presence: true

  validates :role_id, inclusion: { allow_blank: true, in:
    proc { |record| record.work.try(:available_role_ids) || [] }
  }

  def role_name
    role.try(:name)
  end

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list,  -> { }
  scope :for_show,  -> { includes(:work, :creator, :role) }
end
