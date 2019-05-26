# frozen_string_literal: true

FactoryBot.define do
  factory :radio_show, class: "RadioShow" do
    factory :minimal_radio_show,  class: "RadioShow", parent: :minimal_work_parent
    factory :complete_radio_show, class: "RadioShow", parent: :complete_work_parent
    factory :stuffed_radio_show,  class: "RadioShow", parent: :stuffed_work_parent
  end
end
