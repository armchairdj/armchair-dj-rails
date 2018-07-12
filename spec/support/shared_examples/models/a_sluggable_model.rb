# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_sluggable_model" do
  describe "class" do
    describe "self#prepare_parts" do
      subject { described_class.prepare_parts(parts) }

      describe "basics" do
        let(:parts) { ["Kate Bush", "Hounds of Love", "Remastered Version"] }

        it { is_expected.to eq(["kate_bush", "hounds_of_love", "remastered_version"]) }
      end

      describe "nil parts" do
        let(:parts) { ["Kate Bush", "Hounds of Love", nil] }

        it { is_expected.to eq(["kate_bush", "hounds_of_love"]) }
      end

      describe "blankable parts" do
        let(:parts) { ["Talk Talk", "?", nil] }

        it { is_expected.to eq(["talk_talk"]) }
      end

      describe "blankable parts redux" do
        let(:parts) { ["Glass Candy", "///", nil] }

        it { is_expected.to eq(["glass_candy"]) }
      end
    end

    describe "self#prepare_part" do
      subject { described_class.prepare_part(part) }

      describe "underscores and lowercases" do
        let(:part) { "Ray of Light" }

        it { is_expected.to eq("ray_of_light") }
      end

      describe "replaces &" do
        let(:part) { "Key & Peele" }

        it { is_expected.to eq("key_and_peele") }
      end

      describe "replaces & in the middle of a word" do
        let(:part) { "Key&Peele" }

        it { is_expected.to eq("key_and_peele") }
      end

      describe "replaces apostrophes" do
        let(:part) { "Jane's Addiction" }

        it { is_expected.to eq("janes_addiction") }
      end

      describe "replaces curly apostrophes" do
        let(:part) { "Jane’s Addiction" }

        it { is_expected.to eq("janes_addiction") }
      end

      describe "replaces single curly quotes" do
        let(:part) { "‘Heroes’" }

        it { is_expected.to eq("heroes") }
      end

      describe "replaces single straight quotes" do
        let(:part) { "'Heroes'" }

        it { is_expected.to eq("heroes") }
      end

      describe "replaces double curly quotes" do
        let(:part) { "“Heroes”" }

        it { is_expected.to eq("heroes") }
      end

      describe "replaces double straight quotes" do
        let(:part) { '"Heroes"' }

        it { is_expected.to eq("heroes") }
      end

      describe "replaces punctuation" do
        let(:part) { "Damn. I love it! Yeah" }

        it { is_expected.to eq("damn_i_love_it_yeah") }
      end

      describe "replaces and collapses whitespace" do
        let(:part) { "what    is \n\n\t\t\t all this whitespace" }

        it { is_expected.to eq("what_is_all_this_whitespace") }
      end

      describe "replaces non-word characters" do
        let(:part) { "What-Am-I-Worth" }

        it { is_expected.to eq("what_am_i_worth") }
      end

      describe "does not leave leading or trailing underscores" do
        let(:part) { "_Super_Collider_" }

        it { is_expected.to eq("super_collider") }
      end

      describe "collapses underscores" do
        let(:part) { "_____Who? What?When? Where?__ why? How?____" }

        it { is_expected.to eq("who_what_when_where_why_how") }
      end

      describe "ASCII-fies non-ASCII word characters" do
        let(:part) { "Sigur Rós" }

        it { is_expected.to eq("sigur_ros") }
      end
    end
  end

  describe "included" do
    pending "includes friendly_id"
    pending "#normalize_friendly_id"
    pending "#slug_candidates"
    pending "#base_slug"
    pending "#sequenced_slug"
    pending "#sluggable_parts"
    pending "#generate_slug_from_parts"

    describe "generates new slug" do
      describe "#clear_slug?" do
        describe "false by default" do
          subject { build_minimal_instance.clear_slug? }

          it { is_expected.to eq(false) }
        end

        describe "true" do
          subject { build_minimal_instance(clear_slug: true).clear_slug? }

          it { is_expected.to eq(true) }
        end
      end

      describe "#handle_cleared_slug" do
        before(:each) do
          allow(subject).to receive(:slug_candidates).and_call_original
        end

        describe "false" do
          subject { create_minimal_instance }

          before(:each) { expect(subject).to_not receive(:slug_candidates) }

          it { subject.save }
        end

        describe "true" do
          subject do
            instance            = create_minimal_instance
            instance.clear_slug = "1"
            instance
          end

          before(:each) do
            expect(subject).to receive(:slug_candidates)
          end

          it { subject.save }
        end
      end
    end
  end
end
