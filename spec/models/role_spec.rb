require "rails_helper"

RSpec.describe Role, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"
  end

  context "scope-related" do
    context "basics" do
      let!(    :first) { create(:minimal_role, name: "First" ) }
      let!(   :middle) { create(:minimal_role, name: "Middle") }
      let!(     :last) { create(:minimal_role, name: "Last"  ) }
      let(       :ids) { [first, middle, last].map(&:id) }
      let(:collection) { described_class.where(id: ids) }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:contributions, :works) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        specify "includes all, unsorted" do
          is_expected.to match_array([first, middle, last])
        end

        it { is_expected.to eager_load(:contributions, :works) }
      end
    end
  end

  context "associations" do
    it { is_expected.to have_many(:contributions) }

    it { is_expected.to have_many(:works).through(:contributions) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:work_type) }
    it { is_expected.to validate_inclusion_of(:work_type).in_array(Work.valid_types) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:work_type) }
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.display_medium, instance.name]) }
    end

    describe "#display_name" do
      describe "basic" do
        subject { instance.display_name }

        it { is_expected.to eq(instance.name) }
      end

      describe "full" do
        subject { instance.display_name(full: true) }

        it { is_expected.to eq("#{instance.display_medium}: #{instance.name}") }
      end
    end

    describe "#display_medium" do
      describe "basic" do
        subject { create_minimal_instance(work_type: "TvEpisode").display_medium }

        it { is_expected.to eq("TV Episode") }
      end
    end
  end
end
