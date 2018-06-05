require "rails_helper"

RSpec.describe Facet, type: :model do
  context "concerns" do
    it_behaves_like "an_acts_as_list_model", 0, :medium do
      let(:one) { create(:complete_medium).facets }
      let(:two) { create(:complete_medium).facets }
    end

    it_behaves_like "an_application_record"
  end

  context "scope-related" do
    context "basics" do
      let!(:medium_z) { create(:minimal_medium, name: "Medium Z") }
      let!(:medium_a) { create(:minimal_medium, name: "Medium A") }

      let!(:z_1) { create(:minimal_facet, medium: medium_z) }
      let!(:z_2) { create(:minimal_facet, medium: medium_z) }

      let!(:a_1) { create(:minimal_facet, medium: medium_a) }
      let!(:a_2) { create(:minimal_facet, medium: medium_a) }

      let(:ids) { [z_1, z_2, a_1, a_2].map(&:id) }

      before(:each) do
        a_2.move_to_top
      end

      describe "self#eager" do
        subject { described_class.eager }

        it { is_expected.to eager_load(:medium, :category) }
      end

      describe "self#sorted" do
        subject { described_class.sorted.where(id: ids) }

        it { is_expected.to_not  eager_load(:medium, :category) }

        it "sorts by category and position" do
          is_expected.to eq([a_2, a_1, z_1, z_2])
        end
      end

      describe "self#for_admin" do
        subject { described_class.for_admin.where(id: ids) }

        specify "includes all, sorted" do
          is_expected.to eq([a_2, a_1, z_1, z_2])
        end

        it { is_expected.to eager_load(:medium, :category) }
      end

      describe "self#for_site" do
        subject { described_class.for_site.where(id: ids) }

        specify "includes all, sorted" do
          is_expected.to eq([a_2, a_1, z_1, z_2])
        end

        it { is_expected.to eager_load(:medium, :category) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:medium) }

    it { is_expected.to belong_to(:category) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:medium) }

    it { is_expected.to validate_presence_of(:category) }
  end
end
