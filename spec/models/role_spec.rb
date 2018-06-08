require "rails_helper"

RSpec.describe Role, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"
  end

  context "class" do
    describe "self#options_for" do
      let(:medium_1) { create(:complete_medium) }
      let(:medium_2) { create(:complete_medium) }

      subject { described_class.options_for(medium_1) }

      it { is_expected.to eq(medium_1.roles.alpha) }
    end
  end

  context "scope-related" do
    context "basics" do
      let!( :first) { create(:minimal_role, name: "First" ) }
      let!(:middle) { create(:minimal_role, name: "Middle") }
      let!(  :last) { create(:minimal_role, name: "Last"  ) }

      let(:ids) { [first, middle, last].map(&:id) }

      describe "self#eager" do
        subject { described_class.eager }

        it { is_expected.to eager_load(:medium, :contributions, :works, :reviews) }
      end

      describe "self#for_admin" do
        subject { described_class.for_admin.where(id: ids) }

        specify "includes all, unsorted" do
          is_expected.to match_array([first, middle, last])
        end

        it { is_expected.to eager_load(:medium, :contributions, :works, :reviews) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:medium) }

    it { is_expected.to have_many(:contributions) }

    it { is_expected.to have_many(:works).through(:contributions) }

    it { is_expected.to have_many(:reviews).through(:works) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:medium) }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:medium_id) }
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.medium.alpha_parts, instance.name]) }
    end

    describe "#display_name" do
      describe "basic" do
        subject { instance.display_name }

        it { is_expected.to eq(instance.name) }
      end

      describe "full" do
        subject { instance.display_name(full: true) }

        it { is_expected.to eq("#{instance.medium.name}: #{instance.name}") }
      end
    end
  end
end
