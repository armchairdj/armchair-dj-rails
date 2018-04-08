require 'ffaker'

FactoryBot.define do
  factory :creator do
    factory :minimal_creator, parent: :musician do; end

    factory :musician do
      name { FFaker::Music.unique.artist }
    end

    factory :director do
      name { FFaker::Name.unique.name }
    end

    factory :showrunner do
      name { FFaker::Name.unique.name }
    end

    factory :author do
      name { FFaker::Name.unique.name }
    end

    factory :cartoonist do
      name { FFaker::Name.unique.name }
    end

    factory :programmer do
      name { FFaker::Name.unique.name }
    end

    factory :artist do
      name { FFaker::Name.unique.name }
    end
  end
end
