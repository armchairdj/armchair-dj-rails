# frozen_string_literal: true

concern :Imageable do
  included do
    has_one_attached  :hero_image
    has_many_attached :additional_images
  end
end
