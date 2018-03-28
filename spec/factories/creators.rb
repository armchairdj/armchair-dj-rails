FactoryBot.define do

  #############################################################################
  # SEQUENCES.
  #############################################################################

  sequence :creator_name do |n|
    "Creator Name #{n}"
  end

  #############################################################################
  # FACTORIES.
  #############################################################################

  factory :creator do
    factory :minimal_creator do
      name { generate(:creator_name) }
    end
  end
end
