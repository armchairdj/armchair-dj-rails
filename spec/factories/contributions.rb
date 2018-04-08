require 'ffaker'

FactoryBot.define do
  factory :contribution do
    factory :minimal_contribution do
      association :work, factory: :work_for_contribution_factory
      association :creator, factory: :minimal_creator
      role :creator
    end
  end
end
