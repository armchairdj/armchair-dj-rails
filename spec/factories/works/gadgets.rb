# frozen_string_literal: true

FactoryBot.define do
  factory :gadget, class: "Gadget" do
    factory :minimal_gadget,  class: "Gadget", parent: :minimal_work_parent
    factory :complete_gadget, class: "Gadget", parent: :complete_work_parent
    factory :stuffed_gadget,  class: "Gadget", parent: :stuffed_work_parent
  end
end
