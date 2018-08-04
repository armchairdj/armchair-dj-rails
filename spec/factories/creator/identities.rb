# frozen_string_literal: true
# == Schema Information
#
# Table name: creator_identities
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pseudonym_id :bigint(8)
#  real_name_id :bigint(8)
#
# Indexes
#
#  index_creator_identities_on_pseudonym_id  (pseudonym_id)
#  index_creator_identities_on_real_name_id  (real_name_id)
#
# Foreign Keys
#
#  fk_rails_...  (pseudonym_id => creators.id)
#  fk_rails_...  (real_name_id => creators.id)
#

FactoryBot.define do
  factory :creator_identity, class: Creator::Identity do
    trait :with_associations do
      association :real_name, factory: :primary_creator
      association :pseudonym, factory: :secondary_creator
    end

    factory :minimal_creator_identity do
      with_associations
    end
  end
end
