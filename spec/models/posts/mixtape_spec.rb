# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mixtape, type: :model do
  describe "concerns" do
    specify { expect(described_class.superclass).to eq(Post) }
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    describe "basics" do
      let!(      :draft) { create_minimal_instance(:draft    ) }
      let!(  :scheduled) { create_minimal_instance(:scheduled) }
      let!(  :published) { create_minimal_instance(:published) }
      let!(        :ids) { [draft, scheduled, published].map(&:id) }
      let!( :collection) { described_class.where(id: ids) }
      let!(:eager_loads) { [:author, :links, :tags, :playlist, :playlistings, :works, :makers, :contributions, :aspects, :milestones] }

      describe "self#for_show" do
        subject { collection.for_show }

        it { is_expected.to contain_exactly(*collection.to_a) }
        it { is_expected.to eager_load(eager_loads) }
      end

      pending "self#for_list"

      describe "self#for_public" do
        subject { collection.for_public }

        it { is_expected.to eq [published] }
        it { is_expected.to_not eager_load(eager_loads) }
      end
    end
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
