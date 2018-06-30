# == Schema Information
#
# Table name: aspects
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  facet      :integer          not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_aspects_on_alpha  (alpha)
#  index_aspects_on_facet  (facet)
#

require "rails_helper"

RSpec.describe Aspect, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let(      :draft) { create(:minimal_aspect,                       facet: :musical_genre, name: "Trip-Hop" ) }
      let(:published_1) { create(:minimal_aspect, :with_published_post, facet: :musical_mood,  name: "Paranoid" ) }
      let(:published_2) { create(:minimal_aspect, :with_published_post, facet: :musical_genre, name: "Downtempo") }

      let(        :ids) { [draft, published_1, published_2].map(&:id) }
      let( :collection) { described_class.where(id: ids) }
      let(:eager_loads) { [:works, :creators, :contributors, :playlists, :mixtapes, :reviews] }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(eager_loads) }
        it { is_expected.to contain_exactly(draft, published_1, published_2) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        it { is_expected.to eager_load(eager_loads) }
        it { is_expected.to contain_exactly(draft, published_1, published_2) }
      end
    end

    describe "#for_facet" do
      let!( :mood_a) { create(:minimal_aspect, facet: :musical_mood,  name: "Paranoid" ) }
      let!( :mood_b) { create(:minimal_aspect, facet: :musical_mood,  name: "Uplifting") }
      let!(:genre_a) { create(:minimal_aspect, facet: :musical_genre, name: "Trip-Hop" ) }
      let!(:genre_b) { create(:minimal_aspect, facet: :musical_genre, name: "Downtempo") }

      context "single facet" do
        subject { described_class.for_facet(:musical_mood) }

        it { is_expected.to contain_exactly(mood_a, mood_b) }
      end

      context "multiple facets" do
        subject { described_class.for_facet(:musical_mood, :musical_genre) }

        it { is_expected.to contain_exactly(mood_a, mood_b, genre_a, genre_b) }
      end

      context "no facets" do
        subject { described_class.for_facet(nil) }

        it { is_expected.to be_empty }
      end
    end
  end

  context "associations" do
    it { is_expected.to have_and_belong_to_many(:works) }

    it { is_expected.to have_many(:creators    ).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }
    it { is_expected.to have_many(:playlists   ).through(:works) }
    it { is_expected.to have_many(:mixtapes    ).through(:works) }
    it { is_expected.to have_many(:reviews     ).through(:works) }
  end

  context "attributes" do
    context "enums" do
      it { is_expected.to define_enum_for(:facet) }

      it_behaves_like "an_enumable_model", [:facet]
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:facet) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:facet) }
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.human_facet, instance.name]) }
    end

    describe "#display_name" do
      subject { create_minimal_instance(facet: :musical_genre, name: "Trip-Hop") }

      specify { expect(subject.display_name                ).to eq("Musical Genre: Trip-Hop") }
      specify { expect(subject.display_name(connector: "/")).to eq("Musical Genre/Trip-Hop" ) }
    end
  end
end
