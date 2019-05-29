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

require "ffaker"

FactoryBot.define do
  factory :credit, class: "Credit" do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_credit, parent: :credit_with_creator

    factory :credit_without_creator do
      with_work
    end

    factory :credit_with_creator do
      with_work
      with_creator
    end
  end
end
