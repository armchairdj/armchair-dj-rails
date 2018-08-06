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

class Credit < Attribution

  #############################################################################
  # CONCERNING: Work.
  #############################################################################

  belongs_to :work, inverse_of: :credits

  #############################################################################
  # CONCERNING: Creator.
  #############################################################################

  belongs_to :creator, inverse_of: :credits

  validates :creator_id, uniqueness: { scope: [:work_id] }

  #############################################################################
  # Concerning: Role.
  #############################################################################

  def role_name
    "Creator"
  end

  #############################################################################
  # Concerning: Acts As List.
  #############################################################################

  include Listable

  acts_as_listable(:work)

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list,  -> { }
  scope :for_show,  -> { includes(:work, :creator) }
end
