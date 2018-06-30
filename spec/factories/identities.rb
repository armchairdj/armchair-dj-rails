# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pseudonym_id :bigint(8)
#  real_name_id :bigint(8)
#
# Indexes
#
#  index_identities_on_pseudonym_id  (pseudonym_id)
#  index_identities_on_real_name_id  (real_name_id)
#
# Foreign Keys
#
#  fk_rails_...  (pseudonym_id => creators.id)
#  fk_rails_...  (real_name_id => creators.id)
#


FactoryBot.define do
  factory :identity do
    factory :minimal_identity do
      with_associations
    end

    trait :with_associations do
      association :real_name, factory: :primary_creator
      association :pseudonym, factory: :secondary_creator
    end
  end
end
