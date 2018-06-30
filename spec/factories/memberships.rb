# frozen_string_literal: true

# == Schema Information
#
# Table name: memberships
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  member_id  :bigint(8)
#
# Indexes
#
#  index_memberships_on_group_id   (group_id)
#  index_memberships_on_member_id  (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => creators.id)
#  fk_rails_...  (member_id => creators.id)
#


FactoryBot.define do
  factory :membership do
    factory :minimal_membership do
      with_associations
    end

    trait :with_associations do
      association :group,  factory: :collective_creator
      association :member, factory: :individual_creator
    end
  end
end
