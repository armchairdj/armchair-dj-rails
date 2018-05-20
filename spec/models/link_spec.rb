require "rails_helper"

RSpec.describe Link, type: :model do
  context "associations" do
    it { should belong_to(:linkable) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:url) }

    it { should validate_urlness_of(:url) }

    it { should validate_presence_of(:description) }
  end
end
