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
      pending "self#eager"
      pending "self#for_admin"
      pending "self#for_site"
    end

    context "by category" do
      pending "self#categorized"
      pending "self#uncategorized"
      pending "self#for_posts"
      pending "self#for_works"
      pending "categorized?"
      pending "uncategorized?"
    end

    context "by format" do
      pending "self#string"
      pending "self#year"
      pending "string?"
      pending "year?"
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
