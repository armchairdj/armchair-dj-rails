# frozen_string_literal: true

# == Schema Information
#
# Table name: aspects
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  key        :integer          not null
#  val        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_aspects_on_alpha  (alpha)
#  index_aspects_on_key    (key)
#

require "rails_helper"

RSpec.describe Aspect do
  it_behaves_like "an_application_record"

  it_behaves_like "an_alphabetizable_model"

  it_behaves_like "a_ginsu_model" do
    let(:list_loads) { [] }
    let(:show_loads) { [:works, :makers, :contributors, :playlists, :mixtapes, :reviews] }
  end

  describe "nilify_blanks" do
    subject(:instance) { build_minimal_instance }

    it { is_expected.to nilify_blanks(before: :validation) }
  end

  describe "scope-related" do
    describe "#for_key" do
      let!(:mood_a) { create(:minimal_aspect, key: :musical_mood,  val: "Paranoid") }
      let!(:mood_b) { create(:minimal_aspect, key: :musical_mood,  val: "Uplifting") }
      let!(:genre_a) { create(:minimal_aspect, key: :musical_genre, val: "Trip-Hop") }
      let!(:genre_b) { create(:minimal_aspect, key: :musical_genre, val: "Downtempo") }

      context "with single key" do
        subject(:association) { described_class.for_key(:musical_mood) }

        it { is_expected.to contain_exactly(mood_a, mood_b) }
      end

      context "with multiple keys" do
        subject(:association) { described_class.for_key(:musical_mood, :musical_genre) }

        it { is_expected.to contain_exactly(mood_a, mood_b, genre_a, genre_b) }
      end

      context "with no keys" do
        subject(:association) { described_class.for_key(nil) }

        it { is_expected.to be_empty }
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_and_belong_to_many(:works) }

    it { is_expected.to have_many(:makers).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }
    it { is_expected.to have_many(:playlists).through(:works) }
    it { is_expected.to have_many(:mixtapes).through(:works) }
    it { is_expected.to have_many(:reviews).through(:works) }
  end

  describe "attributes" do
    describe "enums" do
      it_behaves_like "a_model_with_a_better_enum_for", :key
    end
  end

  describe "validations" do
    subject(:instance) { build_minimal_instance }

    it { is_expected.to validate_presence_of(:key) }

    it { is_expected.to validate_presence_of(:val) }
    it { is_expected.to validate_uniqueness_of(:val).scoped_to(:key) }
  end

  describe "instance" do
    describe "#alpha_parts" do
      subject(:alpha_parts) { instance.alpha_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.human_key, instance.val]) }
    end

    describe "#display_val" do
      subject(:instance) { build_minimal_instance(key: :musical_genre, val: "Trip-Hop") }

      specify { expect(instance.display_val).to eq("Genre: Trip-Hop") }
      specify { expect(instance.display_val(connector: "/")).to eq("Genre/Trip-Hop") }
    end
  end
end
