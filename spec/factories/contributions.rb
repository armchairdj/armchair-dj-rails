require "ffaker"

FactoryBot.define do
  factory :contribution do
    factory :minimal_contribution, parent: :contribution_with_existing_creator do; end

    factory :contribution_without_creators do
      association :work, factory: :minimal_work
      role        :creator
    end

    factory :contribution_with_new_creator, parent: :contribution_without_creators do
      creator_attributes { {
        '0' => { 'name' => FFaker::Music.artist }
      } }
    end

    factory :contribution_with_existing_creator, parent: :contribution_without_creators do
      association :creator, factory: :minimal_creator
    end
  end
end
