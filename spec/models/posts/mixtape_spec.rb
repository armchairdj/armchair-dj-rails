# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mixtape do
  describe "image attachments" do
    pending "delegate hero_image to playlist"
    pending "delegate additional_images to playlist"
  end

  it_behaves_like "a_ginsu_model" do
    let(:list_loads) { [:author, :playlist] }
    let(:show_loads) { [:playlist, :tracks, :works, :makers, :contributions, :aspects, :milestones] }
  end

  describe "STI inheritance" do
    specify { expect(described_class.superclass).to eq(Post) }

    describe "type" do
      subject { described_class.new.type }

      it { is_expected.to eq("Mixtape") }
    end

    describe "#display_type" do
      let(:instance) { build_minimal_instance }

      specify { expect(instance.display_type).to eq("Mixtape") }
      specify { expect(instance.display_type(plural: true)).to eq("Mixtapes") }
    end
  end

  describe "status" do
    it_behaves_like "a_model_with_a_better_enum_for", :status
  end

  describe "playlist" do
    it { is_expected.to belong_to(:playlist).required }

    it { is_expected.to validate_presence_of(:playlist) }

    it { is_expected.to have_many(:tracks).through(:playlist) }
    it { is_expected.to have_many(:works).through(:tracks) }

    it { is_expected.to have_many(:makers).through(:works) }
    it { is_expected.to have_many(:contributions).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }
    it { is_expected.to have_many(:aspects).through(:works) }
    it { is_expected.to have_many(:milestones).through(:works) }
  end

  describe "sluggable" do
    it_behaves_like "a_sluggable_model"

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.playlist.title]) }
    end

    describe "#reset_slug_history" do
      subject(:call_method) { instance.send(:reset_slug_history) }

      let(:instance) do
        playlist = create(:minimal_playlist, title: "foo")
        instance = create_minimal_instance(:published, playlist: playlist)

        playlist.update!(title: "bar")
        instance.update!(clear_slug: true)

        playlist.update!(title: "bat")
        instance.update!(clear_slug: true)

        instance
      end

      it "removes all old slugs so they can be reused" do
        expect { call_method }.to change(instance.slugs, :count).from(3).to(0)
      end
    end
  end

  describe "alpha" do
    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.playlist.title]) }
    end
  end
end
