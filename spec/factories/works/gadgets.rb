FactoryBot.define do
  factory :gadget, class: "Gadget" do
    factory :minimal_gadget,  class: "Gadget", parent: :minimal_work_parent  do; end
    factory :complete_gadget, class: "Gadget", parent: :complete_work_parent do; end
    factory :stuffed_gadget,  class: "Gadget", parent: :stuffed_work_parent  do; end
  end
end
