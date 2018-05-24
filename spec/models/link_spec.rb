require "rails_helper"

RSpec.describe Link, type: :model do
  context "associations" do
    it { is_expected.to belong_to(:linkable) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:url) }

    it { is_expected.to validate_urlness_of(:url) }

    it { is_expected.to validate_presence_of(:description) }
  end
end
