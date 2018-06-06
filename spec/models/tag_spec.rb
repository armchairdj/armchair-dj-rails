require "rails_helper"

RSpec.describe Tag, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_displayable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let(        :uv) { create(:minimal_tag, :with_published_post,  name: "UV") }
      let(        :cv) { create(:minimal_tag, :with_viewable_work,   name: "CV") }
      let(        :uu) { create(:minimal_tag, :with_draft_post,      name: "UU") }
      let(        :cu) { create(:minimal_tag, :with_unviewable_work, name: "CU") }
      let(       :ids) { [cu, cv, uu, uv].map(&:id) }
      let(:collection) { described_class.where(id: ids) }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:category) }
        it { is_expected.to eager_load(:works   ) }
        it { is_expected.to eager_load(:posts   ) }

        it { is_expected.to contain_exactly(cu, cv, uu, uv) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        it { is_expected.to contain_exactly(cu, cv, uu, uv) }
        it { is_expected.to eager_load(:category, :works, :posts) }
      end

      describe "self#for_site" do
        subject { collection.for_site }

        it { is_expected.to eq([cv, uv]) }
        it { is_expected.to eager_load(:category, :works, :posts) }
      end
    end

    context "by category" do
      let(:for_post_1) { create(:tag_for_post, name: "Z") }
      let(:for_post_2) { create(:tag_for_post, name: "A") }
      let(:for_work_1) { create(:tag_for_work, name: "X", category_name: "Foo") }
      let(:for_work_2) { create(:tag_for_work, name: "X", category_name: "Bar") }
      let(       :ids) { [for_post_1, for_post_2, for_work_1, for_work_2].map(&:id) }
      let(:collection) { described_class.where(id: ids) }

      describe "self#categorized" do
        subject { collection.categorized }

        it { is_expected.to_not eager_load(:category, :works, :posts) }

        it { is_expected.to match_array([for_work_1, for_work_2]) }
      end

      describe "self#uncategorized" do
        subject { collection.uncategorized }

        it { is_expected.to_not eager_load(:category, :works, :posts) }

        it { is_expected.to match_array([for_post_1, for_post_2]) }
      end

      describe "self#for_posts" do
        subject { collection.for_posts }

        it { is_expected.to eager_load(:category, :works, :posts) }

        it { is_expected.to eq([for_post_2, for_post_1]) }
      end

      describe "self#for_works" do
        subject { collection.for_works }

        it { is_expected.to eager_load(:category, :works, :posts) }

        it { is_expected.to eq([for_work_2, for_work_1]) }
      end

      describe "categorized?" do
        specify { expect(for_post_1.categorized?).to eq(false) }
        specify { expect(for_post_2.categorized?).to eq(false) }
        specify { expect(for_work_1.categorized?).to eq(true ) }
        specify { expect(for_work_2.categorized?).to eq(true ) }
      end

      describe "uncategorized?" do
        specify { expect(for_post_1.uncategorized?).to eq(true ) }
        specify { expect(for_post_2.uncategorized?).to eq(true ) }
        specify { expect(for_work_1.uncategorized?).to eq(false) }
        specify { expect(for_work_2.uncategorized?).to eq(false) }
      end
    end

    context "by format" do
      let!(    :string) { create(:string_tag) }
      let!(      :year) { create(:year_tag) }
      let!(       :ids) { [string, year].map(&:id) }
      let!(:collection) { described_class.where(id: ids) }

      describe "self#string" do
        subject { collection.string }

        it { is_expected.to eager_load(:category, :works, :posts) }

        it { is_expected.to eq([string]) }
      end

      describe "self#year" do
        subject { collection.year }

        it { is_expected.to eager_load(:category, :works, :posts) }

        it { is_expected.to eq([year]) }
      end

      describe "string?" do
        specify { expect(string.string?).to eq(true ) }
        specify { expect(  year.string?).to eq(false) }
      end

      describe "year?" do
        specify { expect(string.year?).to eq(false) }
        specify { expect(  year.year?).to eq(true ) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:category).optional }

    it { is_expected.to have_and_belong_to_many(:posts) }

    it { is_expected.to have_and_belong_to_many(:works) }

    it { is_expected.to have_many(:creators    ).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }
    it { is_expected.to have_many(:reviews     ).through(:works) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:category_id) }

    it { is_expected.to_not  validate_presence_of(:category_id) }

    context "conditional" do
      describe "yearness" do
        context "for tag with year category" do
          subject { create(:year_tag) }

          it { is_expected.to validate_yearness_of(:name) }
        end

        context "for tag with string category" do
          subject { build(:complete_tag, name: "not_a_year") }

          it { is_expected.to_not  have_error(:name, :not_a_url) }
        end
      end
    end
  end

  context "instance" do
    let(     :category) { create(:category, name: "Category") }
    let(:uncategorized) { create(:tag, name: "Uncategorized") }
    let(  :categorized) { create(:tag, name: "Categorized", category_id: category.id) }

    describe "#sluggable_parts" do
      specify { expect(uncategorized.sluggable_parts).to eq(["Uncategorized"       ]) }
      specify { expect(  categorized.sluggable_parts).to eq(["Category/Categorized"]) }
    end

    describe "#alpha_parts" do
      specify { expect(uncategorized.alpha_parts).to eq(["Uncategorized"          ]) }
      specify { expect(  categorized.alpha_parts).to eq(["Category", "Categorized"]) }
    end

    describe "#display_category" do
      specify { expect(  categorized.display_category                ).to eq("Category"     ) }
      specify { expect(uncategorized.display_category                ).to eq("Uncategorized") }
      specify { expect(uncategorized.display_category(default: "foo")).to eq("foo"          ) }
    end

    describe "#display_name" do
      specify { expect(uncategorized.display_name).to eq("Uncategorized"        ) }
      specify { expect(  categorized.display_name).to eq("Category: Categorized") }
    end

    pending "#all_posts"
  end
end
