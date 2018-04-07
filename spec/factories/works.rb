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
    factory :work_for_contribution_factory do
      medium :song

      title { generate(:work_title) }
    end

    factory :single_creator_work do
      medium :song

      title { generate(:work_title) }

      contributions_attributes { {
        "0" => attributes_for(:contribution, role: :creator, creator_id: create(:minimal_creator).id)
      } }

      factory :minimal_work do
        # Just a single-creator work
      end
    end
  end
end
