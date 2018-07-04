# == Schema Information
#
# Table name: tags
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_alpha  (alpha)
#

require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_alphabetizable_model"
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    describe "basics" do
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

  describe "associations" do
    it { is_expected.to have_and_belong_to_many(:posts) }
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe "instance" do
    let(:instance) { create_minimal_instance }

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.name]) }
    end
  end
end
