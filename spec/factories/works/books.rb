# frozen_string_literal: true

FactoryBot.define do
  factory :book, class: "Book" do
    factory :minimal_book,  class: "Book", parent: :minimal_work_parent  do; end
    factory :complete_book, class: "Book", parent: :complete_work_parent do; end
    factory :stuffed_book,  class: "Book", parent: :stuffed_work_parent  do; end
  end
end
