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

RSpec.describe Aspect do
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_eager_loadable_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:works, :makers, :contributors, :playlists, :mixtapes, :reviews] }
    end

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    describe "#for_facet" do
      let!(:mood_a) { create(:minimal_aspect, facet: :musical_mood,  name: "Paranoid" ) }
      let!(:mood_b) { create(:minimal_aspect, facet: :musical_mood,  name: "Uplifting") }
      let!(:genre_a) { create(:minimal_aspect, facet: :musical_genre, name: "Trip-Hop" ) }
      let!(:genre_b) { create(:minimal_aspect, facet: :musical_genre, name: "Downtempo") }

      describe "single facet" do
        subject { described_class.for_facet(:musical_mood) }

        it { is_expected.to contain_exactly(mood_a, mood_b) }
      end

      describe "multiple facets" do
        subject { described_class.for_facet(:musical_mood, :musical_genre) }

        it { is_expected.to contain_exactly(mood_a, mood_b, genre_a, genre_b) }
      end

      describe "no facets" do
        subject { described_class.for_facet(nil) }

        it { is_expected.to be_empty }
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_and_belong_to_many(:works) }

    it { is_expected.to have_many(:makers      ).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }
    it { is_expected.to have_many(:playlists   ).through(:works) }
    it { is_expected.to have_many(:mixtapes    ).through(:works) }
    it { is_expected.to have_many(:reviews     ).through(:works) }
  end

  describe "attributes" do
    describe "enums" do
      it_behaves_like "an_enumable_model", [:facet]
    end
  end

  describe "validations" do
    subject { build_minimal_instance }

    it { is_expected.to validate_presence_of(:facet) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:facet) }
  end

  describe "instance" do
    let(:instance) { build_minimal_instance }

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.human_facet, instance.name]) }
    end

    describe "#display_name" do
      subject { build_minimal_instance(facet: :musical_genre, name: "Trip-Hop") }

      specify { expect(subject.display_name                ).to eq("Musical Genre: Trip-Hop") }
      specify { expect(subject.display_name(connector: "/")).to eq("Musical Genre/Trip-Hop" ) }
    end
  end
end
