# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: "Product" do
    factory :minimal_product,  class: "Product", parent: :minimal_work_parent
    factory :complete_product, class: "Product", parent: :complete_work_parent
    factory :stuffed_product,  class: "Product", parent: :stuffed_work_parent
  end
end
