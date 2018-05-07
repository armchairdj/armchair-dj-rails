require "rails_helper"

RSpec.describe Tag, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

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
  end

  context "associations" do
    it { should belong_to(:category) }

    it { should have_and_belong_to_many(:works) }

    it { should have_and_belong_to_many(:posts) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:name) }

    it { should_not validate_presence_of(:category_id) }
  end

  context "instance" do
    pending "#alpha_parts"
  end
end
