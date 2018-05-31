FactoryBot.define do
  factory :playlisting do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_existing_playlist do
      playlist_id { create(:minimal_playlist).id }
    end

    trait :with_existing_work do
      work_id { create(:minimal_work).id }
    end

    trait :with_post do
      after(:create) do |playlisting|
        create(:review, work_id: playlisting.work.id)

        playlisting.reload
      end
    end


    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_playlisting do
      with_existing_playlist
      with_existing_work
    end

    factory :complete_playlisting, parent: :minimal_playlisting do
      with_post
    end
  end
end
