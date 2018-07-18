# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mixtape, type: :model do
  describe "concerns" do
    it_behaves_like "an_eager_loadable_model" do
      let(:list_loads) { [:author, :playlist] }
      let(:show_loads) { [:playlist, :playlistings, :works, :makers, :contributions, :aspects, :milestones] }
    end
  end

  describe "class" do
    specify { expect(described_class.superclass).to eq(Post) }
  end

  describe "scope-related" do
    # Nothing so far.
  end

  describe "associations" do
    it { is_expected.to belong_to(:playlist) }

    it { is_expected.to have_many(:playlistings).through(:playlist) }
    it { is_expected.to have_many(:works       ).through(:playlistings) }

    it { is_expected.to have_many(:makers       ).through(:works) }
    it { is_expected.to have_many(:contributions).through(:works) }
    it { is_expected.to have_many(:contributors ).through(:works) }
    it { is_expected.to have_many(:aspects      ).through(:works) }
    it { is_expected.to have_many(:milestones   ).through(:works) }
  end

  describe "attributes" do
    # Nothing so far.
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:playlist) }
  end

  describe "instance" do
    let(:instance) { create_minimal_instance }

    describe "#display_type" do
      specify { expect(instance.display_type              ).to eq("Mixtape" ) }
      specify { expect(instance.display_type(plural: true)).to eq("Mixtapes") }
    end

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      it { is_expected.to eq([instance.playlist.title]) }
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.playlist.title]) }
    end
  end
end
