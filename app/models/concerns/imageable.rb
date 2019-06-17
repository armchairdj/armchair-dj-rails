# frozen_string_literal: true

concern :Imageable do
  included do
    has_one_attached :hero_image
    has_many_attached :additional_images

    with_options if: :hero_image_required? do
      validates :hero_image, attached: true
      validates :hero_image, content_type: ["image/png", "image/jpeg"]
      validates :hero_image, dimension: { width: { min: 800 } }
    end
  end

  private

  def hero_image_required?
    false
  end
end
