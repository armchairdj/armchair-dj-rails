require 'ffaker'

FactoryBot.define do
  factory :creator do
    factory :minimal_creator, parent: :musician do; end

    factory :musician do
      name { FFaker::Music.artist }
    end

    factory :director do
      name { FFaker::Name.name }
    end

    factory :showrunner do
      name { FFaker::Name.name }
    end

    factory :radio_host do
      name { FFaker::Name.name }
    end

    factory :podcaster do
      name { FFaker::Name.name }
    end

    factory :author do
      name { FFaker::Name.name }
    end

    factory :cartoonist do
      name { FFaker::Name.name }
    end

    factory :publisher do
      name { FFaker::Name.name }
    end

    factory :artist do
      name { FFaker::Name.name }
    end

    factory :game_platform do
      name { FFaker::Product.brand }
    end

    factory :software_platform do
      name { FFaker::Product.brand }
    end

    factory :hardware_company do
      name { FFaker::Product.brand }
    end

    factory :brand do
      name { FFaker::Product.brand }
    end
  end
end
