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


require "ffaker"

FactoryBot.define do
  factory :contribution do
    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_role do
      association :role, factory: :minimal_role
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_contribution do
      with_role
      with_work
      with_creator
    end
  end
end
