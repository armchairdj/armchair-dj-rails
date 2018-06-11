# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mixtape, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "an_authorable_model"

    it_behaves_like "a_linkable_model"

    it_behaves_like "a_sluggable_model"

    it_behaves_like "a_summarizable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
      let!(     :draft) { create_minimal_instance(:draft    ) }
      let!( :scheduled) { create_minimal_instance(:scheduled) }
      let!( :published) { create_minimal_instance(:published) }
      let!(       :ids) { [draft, scheduled, published].map(&:id) }
      let!(:collection) { described_class.where(id: ids) }

    context "basics" do
      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:author, :tags, :playlist, :playlistings, :works, :creators) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        it { is_expected.to contain_exactly(draft, scheduled, published) }

        it { is_expected.to eager_load(:author, :tags, :playlist, :playlistings, :works, :creators) }
      end

      describe "self#for_site" do
        subject { collection.for_site }

        it { is_expected.to eq [published] }

        it { is_expected.to eager_load(:author, :tags, :playlist, :playlistings, :works, :creators) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:playlist) }

    it { is_expected.to have_many(:playlistings).through(:playlist) }
    it { is_expected.to have_many(:works       ).through(:playlistings) }

    it { is_expected.to have_many(:media       ).through(:works) }
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

    describe "#type" do
      specify { expect(instance.type              ).to eq("Mixtape" ) }
      specify { expect(instance.type(plural: true)).to eq("Mixtapes") }
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
