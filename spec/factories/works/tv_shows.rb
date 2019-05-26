# frozen_string_literal: true

FactoryBot.define do
  factory :tv_show, class: "TvShow" do
    factory :minimal_tv_show,  class: "TvShow", parent: :minimal_work_parent  do; end
    factory :complete_tv_show, class: "TvShow", parent: :complete_work_parent do; end
    factory :stuffed_tv_show,  class: "TvShow", parent: :stuffed_work_parent  do; end
  end
end
