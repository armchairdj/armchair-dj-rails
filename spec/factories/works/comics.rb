# frozen_string_literal: true

FactoryBot.define do
  factory :comic_book, class: "ComicBook" do
    factory :minimal_comic_book,  class: "ComicBook", parent: :minimal_work_parent
    factory :complete_comic_book, class: "ComicBook", parent: :complete_work_parent
    factory :stuffed_comic_book,  class: "ComicBook", parent: :stuffed_work_parent
  end
end
