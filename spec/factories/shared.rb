FactoryBot.define do
  trait :with_summary do
    summary FFaker::HipsterIpsum.paragraphs(1).first
  end
end
