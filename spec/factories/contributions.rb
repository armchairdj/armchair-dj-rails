FactoryBot.define do
  factory :contribution do
    factory :minimal_contribution do
      association :creator, factory: :minimal_creator
      association :work, factory: :single_creator_work
    end
  end
end
