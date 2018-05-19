require "rails_helper"

RSpec.describe Tag, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_summarizable_model"

    it_behaves_like "a_viewable_model"
  end

  context "class" do
    describe "self#admin_scopes" do
      specify "keys are short tab names" do
        expect(described_class.admin_scopes.keys).to eq([
          "All",
          "For Posts",
          "For Works",
        ])
      end
    end
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

    context "conditional" do
      describe "yearness of name" do
        context "tag with year category" do
          subject { create(:year_tag) }

          it "validates yearness" do
            subject.name = "foo"

            expect(subject).not_to be_valid

            should have_error(name: :not_a_year)
          end
        end

        context "tag with string category" do
          subject { create(:complete_tag) }

          it "does not validate yearness" do
            subject.name = "foo"

            expect(subject).to be_valid

            should_not have_error(name: :not_a_year)
          end
        end
      end
    end
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
