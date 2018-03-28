FactoryBot.define do

  #############################################################################
  # SEQUENCES.
  #############################################################################

  sequence :work_title do |n|
    "Work Title #{n}"
  end

  #############################################################################
  # FACTORIES.
  #############################################################################

  factory :work do
    factory :single_creator_work do
      title { generate(:work_title) }
      association :creator, factory: :minimal_creator

      factory :minimal_work do
        # Just a single-creator work
      end
    end
  end
end
