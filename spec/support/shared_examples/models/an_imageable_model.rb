# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_imageable_model" do
  it { should have_one(:hero_image_attachment) }

  it { should have_many(:additional_images_attachments) }
end
