# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mixtape, type: :model do
  context "concerns" do
    specify { expect(described_class.superclass).to eq(Post) }
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let!(      :draft) { create_minimal_instance(:draft    ) }
      let!(  :scheduled) { create_minimal_instance(:scheduled) }
      let!(  :published) { create_minimal_instance(:published) }
      let!(        :ids) { [draft, scheduled, published].map(&:id) }
      let!( :collection) { described_class.where(id: ids) }
      let!(:eager_loads) { [:author, :tags, :playlist, :playlistings, :works, :creators, :contributors, :aspects] }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to contain_exactly(*collection.to_a) }
        it { is_expected.to eager_load(eager_loads) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        it { is_expected.to contain_exactly(*collection.to_a) }
        it { is_expected.to eager_load(eager_loads) }
      end

      describe "self#for_site" do
        subject { collection.for_site }

        it { is_expected.to eq [published] }
        it { is_expected.to eager_load(eager_loads) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:playlist) }

    it { is_expected.to have_many(:playlistings).through(:playlist) }
    it { is_expected.to have_many(:works       ).through(:playlistings) }

    it { is_expected.to have_many(:creators    ).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }
    it { is_expected.to have_many(:aspects     ).through(:works) }
  end

  context "attributes" do
    # Nothing so far.
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:playlist) }
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#display_type" do
      specify { expect(instance.display_type              ).to eq("Mixtape" ) }
      specify { expect(instance.display_type(plural: true)).to eq("Mixtapes") }
    end

    describe "#cascade_viewable" do
      subject { create_minimal_instance }

      before(:each) do
         allow(subject.playlist).to receive(:cascade_viewable)
        expect(subject.playlist).to receive(:cascade_viewable)
      end

      it "updates viewable for descendents" do
        subject.cascade_viewable
      end
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
