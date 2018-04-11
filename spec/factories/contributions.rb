require 'ffaker'

FactoryBot.define do
  factory :contribution do
    factory :minimal_contribution do
      association :work, factory: :work_for_contribution_factory
      association :creator, factory: :minimal_creator
      role :creator
    end

    factory :contribution_with_new_creator do
      association :work, factory: :minimal_work
      role :creator

      creator_attributes { {
        "0" => { "name" => FFaker::Music.artist }
      } }
    end
  end
end
