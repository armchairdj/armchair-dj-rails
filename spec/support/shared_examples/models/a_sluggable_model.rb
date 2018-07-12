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

        it { is_expected.to eq(["talk_talk", "!"]) }
      end

      describe "blankable parts redux" do
        let(:parts) { ["Glass Candy", "///", nil] }

        it { is_expected.to eq(["glass_candy", "!"]) }
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
    describe "generating new slug" do
      describe "#clear_slug?" do
        subject { instance.clear_slug? }

        describe "false by default" do
          let(:instance) { build_minimal_instance }

          it { is_expected.to eq(false) }
        end

        describe "true" do
          let(:instance) { build_minimal_instance(clear_slug: true) }

          it { is_expected.to eq(true) }
        end

        describe "1" do
          let(:instance) { build_minimal_instance(clear_slug: "1") }

          it { is_expected.to eq(true) }
        end
      end

      describe "#handle_cleared_slug" do
        before(:each) do
          allow(instance).to receive(:slug_candidates).and_call_original
        end

        describe "false" do
          let(:instance) { create_minimal_instance }

          it "does not regenerate slug" do
            expect(instance).to_not receive(:slug_candidates)

            instance.save
          end
        end

        describe "true" do
          let(:instance) do
            instance            = create_minimal_instance
            instance.clear_slug = "1"
            instance
          end

          it "regenerates slug" do
            expect(instance).to receive(:slug_candidates)

            instance.save
          end
        end
      end
    end
  end

  describe "instance" do
    let(:instance) { create_minimal_instance }

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      it { is_expected.to be_a_kind_of(Array) }
    end

    context "private" do
      describe "#slug_candidates" do
        subject { instance.send(:slug_candidates) }

        it { is_expected.to eq([:base_slug, :sequenced_slug]) }

        describe "calling #base_slug, #sequenced_slug & #normalize_friendly_id" do
          describe "basic characters" do
            let(  :one) { build_minimal_instance }
            let(  :two) { build_minimal_instance }
            let(:three) { build_minimal_instance }

            let!(:instances) { [one, two, three] }

            before(:each) do
              instances.each do |instance|
                allow(instance).to receive(:sluggable_parts).and_return(["foo", "bar", "bat"])

                instance.save
              end
            end

            it { expect(  one.slug).to eq("foo/bar/bat"  ) }
            it { expect(  two.slug).to eq("foo/bar/bat-2") }
            it { expect(three.slug).to eq("foo/bar/bat-3") }
          end

          describe "special characters" do
            let(  :one) { build_minimal_instance }
            let(  :two) { build_minimal_instance }
            let(:three) { build_minimal_instance }

            let!(:instances) { [one, two, three] }

            before(:each) do
              instances.each do |instance|
                allow(instance).to receive(:sluggable_parts).and_return(["Salt-n-Pepa", "Blacks' Magic", "???"])

                instance.save
              end
            end

            it { expect(  one.slug).to eq("salt_n_pepa/blacks_magic/!"  ) }
            it { expect(  two.slug).to eq("salt_n_pepa/blacks_magic/!-2") }
            it { expect(three.slug).to eq("salt_n_pepa/blacks_magic/!-3") }
          end
        end
      end
    end
  end
end