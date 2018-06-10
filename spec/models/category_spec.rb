require "rails_helper"

RSpec.describe Category, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let!( :first) { create(:minimal_category, name: "First" ) }
      let!(:middle) { create(:minimal_category, name: "Middle") }
      let!(  :last) { create(:minimal_category, name: "Last"  ) }

      let(       :ids) { [first, middle, last].map(&:id) }
      let(:collection) { described_class.where(id: ids) }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:facets, :media, :aspects) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        specify "includes all, unsorted" do
          is_expected.to match_array([first, middle, last])
        end

        it { is_expected.to eager_load(:facets, :media, :aspects) }
      end

      describe "self#for_site" do
        subject { collection.for_site }

        specify "includes all, sorted alphabetically" do
          is_expected.to eq([first, last, middle])
        end

        it { is_expected.to eager_load(:facets, :media, :aspects) }
      end
    end

    context "by multi" do
      let!(    :multi) { create(:minimal_category,    :allowing_multiple) }
      let!(   :single) { create(:minimal_category, :disallowing_multiple) }
      let(       :ids) { [multi, single].map(&:id) }
      let(:collection) { described_class.where(id: ids) }

      describe "self#multi" do
        subject { collection.multi }

        it { is_expected.to contain_exactly(multi) }
      end

      describe "self#single" do
        subject { collection.single }

        it { is_expected.to contain_exactly(single) }
      end

      describe "#multi?" do
        specify { expect( multi.multi?).to eq(true ) }
        specify { expect(single.multi?).to eq(false) }
      end

      describe "#single?" do
        specify { expect( multi.single?).to eq(false) }
        specify { expect(single.single?).to eq(true ) }
      end
    end
  end

  context "associations" do
    it { is_expected.to have_many(:facets) }

    it { is_expected.to have_many(:media).through(:facets) }

    it { is_expected.to have_many(:aspects) }
  end

  context "attributes" do
    # Nothing so far.
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:name) }
  end

  context "instance" do
    describe "#display_name" do
      describe "single" do
        let(:instance) { create_minimal_instance(:disallowing_multiple, name: "Foo") }

        subject { instance.display_name }

        it { is_expected.to eq("Foo") }
      end

      describe "multi" do
        let(:instance) { create_minimal_instance(:allowing_multiple, name: "Foo") }

        subject { instance.display_name }

        it { is_expected.to eq("Foos") }
      end
    end

    describe "#alpha_parts" do
      let(:instance) { create_minimal_instance }

      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.name]) }
    end
  end
end
