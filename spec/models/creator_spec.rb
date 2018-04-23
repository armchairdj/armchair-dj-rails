require "rails_helper"

RSpec.describe Creator, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    it_behaves_like "an application record"
    it_behaves_like "a viewable model"
    it_behaves_like "an atomically validatable model", { name: nil } do
      subject { create(:minimal_creator) }
    end
  end

  context "class" do
    # Nothing so far.
  end

  context "scopes" do
    describe "alphabetical" do
      let!(:zorro  ) { create(:creator, name: "Zorro the Gay Blade") }
      let!(:amy_1  ) { create(:creator, name: "amy winehouse") }
      let!(:kate   ) { create(:creator, name: "Kate Bush") }
      let!(:amy_2  ) { create(:creator, name: "Amy Wino") }
      let!(:anthony) { create(:creator, name: "Anthony Childs") }
      let!(:zero   ) { create(:creator, name: "0773") }

      specify { expect(described_class.alphabetical.to_a).to eq([
        zero,
        amy_1,
        amy_2,
        anthony,
        kate,
        zorro
      ]) }
    end

    pending "eager"

    pending "for_admin"

    pending "for_site"
  end

  context "associations" do
    describe "associations" do
      it { should have_many(:contributions) }

      it { should have_many(:works   ).through(:contributions) }
      it { should have_many(:contributed_works).through(:contributions) }

      it { should have_many(:posts).through(:works) }
    end
  end

  context "attributes" do
    context "nested" do
      # Nothing so far.
    end

    context "enums" do
      # Nothing so far.
    end
  end

  context "validations" do
    describe "name" do
      it { should validate_presence_of(:name) }
    end
  end

  context "hooks" do
    # Nothing so far.
  end

  context "instance" do
    context "meta methods" do
      pending "to_description"
    end

    describe "private" do
      context "callbacks" do
        # Nothing so far.
      end
    end
  end
end
