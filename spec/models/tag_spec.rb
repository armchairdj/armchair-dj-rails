require "rails_helper"

RSpec.describe Tag, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let(      :draft) { create(:minimal_tag,                       name: "D") }
      let(:published_1) { create(:minimal_tag, :with_published_post, name: "Z") }
      let(:published_2) { create(:minimal_tag, :with_published_post, name: "A") }
      let(       :ids) { [draft, published_1, published_2].map(&:id) }
      let(:collection) { described_class.where(id: ids) }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:posts) }
        it { is_expected.to match_array(collection.to_a) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        it { is_expected.to eager_load(:posts) }
        it { is_expected.to match_array(collection.to_a) }
      end
    end
  end

  context "associations" do
    it { is_expected.to have_and_belong_to_many(:posts) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:name) }
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.name]) }
    end
  end
end
