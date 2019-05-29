# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_imageable_model" do
  it { is_expected.to have_one(:hero_image_attachment) }

  it { is_expected.to have_many(:additional_images_attachments) }
end
