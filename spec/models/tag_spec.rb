require "rails_helper"

RSpec.describe Tag, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_summarizable_model"

    it_behaves_like "a_viewable_model"

    it_behaves_like "an_atomically_validatable_model", { name: nil } do
      subject { create(:minimal_tag) }
    end
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
      pending "categorized?"
      pending "uncategorized?"
      pending "self#for_posts"
    end
  end

  context "associations" do
    it { should belong_to(:category) }

    it { should have_and_belong_to_many(:posts) }

    it { should have_and_belong_to_many(:works) }

    it { should have_many(:creators).through(:works) }
    it { should have_many(:reviews ).through(:works) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:name).scoped_to(:category_id) }

    it { should_not validate_presence_of(:category_id) }
  end

  context "instance" do
    let(     :category) { create(:category, name: "Category") }
    let(:uncategorized) { create(:tag, name: "Uncategorized") }
    let(  :categorized) { create(:tag, name: "Categorized", category_id: category.id) }

    describe "#alpha_parts" do
      specify { expect(uncategorized.alpha_parts).to eq(["Uncategorized"          ]) }
      specify { expect(  categorized.alpha_parts).to eq(["Category", "Categorized"]) }
    end

    describe "#display_category" do
      specify { expect(  categorized.display_category       ).to eq("Category"     ) }
      specify { expect(uncategorized.display_category       ).to eq("Uncategorized") }
      specify { expect(uncategorized.display_category("foo")).to eq("foo"          ) }
    end

    describe "#display_name" do
      specify { expect(uncategorized.display_name).to eq("Uncategorized"        ) }
      specify { expect(  categorized.display_name).to eq("Category: Categorized") }
    end

    pending "#all_posts"
  end
end
