require "rails_helper"

RSpec.describe Facet, type: :model do
  context "associations" do
    it { should belong_to(:medium) }

    it { should belong_to(:category) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:medium) }

    it { should validate_presence_of(:category) }
  end
end
