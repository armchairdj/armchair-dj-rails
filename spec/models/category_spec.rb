require "rails_helper"

RSpec.describe Category, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "an_enumable_model", [:format]
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let!( :first) { create(:minimal_category, name: "First" ) }
      let!(:middle) { create(:minimal_category, name: "Middle") }
      let!(  :last) { create(:minimal_category, name: "Last"  ) }

      let(:ids) { [first, middle, last].map(&:id) }

      describe "self#eager" do
        subject { described_class.eager }

        it { is_expected.to eager_load(:facets, :media, :tags) }
      end

      describe "self#for_admin" do
        subject { described_class.for_admin.where(id: ids) }

        specify "includes all, unsorted" do
          is_expected.to match_array([first, middle, last])
        end

        it { is_expected.to eager_load(:facets, :media, :tags) }
      end

      describe "self#for_site" do
        subject { described_class.for_site.where(id: ids) }

        specify "includes all, sorted alphabetically" do
          is_expected.to eq([first, last, middle])
        end

        it { is_expected.to eager_load(:facets, :media, :tags) }
      end
    end

    context "by multi" do
      let!( :multi) { create(:minimal_category,    :allowing_multiple) }
      let!(:single) { create(:minimal_category, :disallowing_multiple) }

      describe "self#multi" do
        subject { described_class.multi }

        it { is_expected.to match_array([multi]) }
      end

      describe "self#single" do
        subject { described_class.single }

        it { is_expected.to match_array([single]) }
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

    context "by format" do
      let!(:string) { create(:minimal_category, :string_format) }
      let!(  :year) { create(:minimal_category,   :year_format) }

      describe "self#string" do
        subject { described_class.string }

        it { is_expected.to match_array([string]) }
      end

      describe "self#year" do
        subject { described_class.year }

        it { is_expected.to match_array([year]) }
      end

      describe "#string?" do
        specify { expect(string.string?).to eq(true ) }
        specify { expect(  year.string?).to eq(false) }
      end

      describe "#year?" do
        specify { expect(string.year?).to eq(false) }
        specify { expect(  year.year?).to eq(true ) }
      end
    end
  end

  context "associations" do
    it { is_expected.to have_many(:facets) }

    it { is_expected.to have_many(:media).through(:facets) }

    it { is_expected.to have_many(:tags) }
  end

  context "attributes" do
    describe "format" do
      it { is_expected.to define_enum_for(:format) }
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:name) }
  end

  context "instance" do
    describe "#display_name" do
      let!(:single) { create(:minimal_category, :disallowing_multiple, name: "Foo") }
      let!( :multi) { create(:minimal_category,    :allowing_multiple, name: "Bar") }

      it "does not pluralize single" do
        expect(single.display_name).to eq("Foo")
      end

      it "pluralizes multi" do
        expect(multi.display_name).to eq("Bars")
      end
    end

    describe "#alpha_parts" do
      subject { create_minimal_instance }

      it "uses name" do
        expect(subject.alpha_parts).to eq([subject.name])
      end
    end
  end
end
