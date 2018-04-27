# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_sluggable_model" do |sluggable_attribute|
  describe "class" do
    describe "#generate_unique_slug" do
      subject { build_minimal_instance }

      it "generates slug for unique base" do
        actual = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, ["Foo Bar", "BAT"])

        expect(actual).to eq("foo_bar/bat")
      end

      it "adds index for non-unique base" do
        existing = create_minimal_instance
        existing.update_column(sluggable_attribute.to_sym, "foo_bar/bat")

        actual   = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, ["Foo Bar", "BAT"])

        expect(actual).to eq("foo_bar/bat/v2")
      end

      it "does not add index for self" do
        subject.save
        subject.update_column(sluggable_attribute.to_sym, "foo_bar/bat")

        actual = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, ["Foo Bar", "BAT"])

        expect(actual).to eq("foo_bar/bat")
      end

      context "real-world examples" do
        specify do
          actual = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, [
            "Sigur Rós", "()"
          ])

          expect(actual).to eq("sigur_ros/_")
        end

        specify do
          actual = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, [
            "Sigur Rós", "Viðrar Vel Til Loftárása"
          ])

          expect(actual).to eq("sigur_ros/vidrar_vel_til_loftarasa")
        end

        specify do
          actual = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, [
            "A.A.L (Against All Logic)", "2012 - 2017"
          ])

          expect(actual).to eq("a_a_l_against_all_logic/2012_2017")
        end

        specify do
          actual = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, [
            "Laurent Garnier", "*?*"
          ])

          expect(actual).to eq("laurent_garnier/_")
        end

        specify do
          actual = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, [
            "Was (Not Was)", "Man vs. the Empire Brain Building"
          ])

          expect(actual).to eq("was_not_was/man_vs_the_empire_brain_building")
        end

        specify do
          actual = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, [
            "Siouxsie & The Banshees", "Kiss Them For Me"
          ])

          expect(actual).to eq("siouxsie_and_the_banshees/kiss_them_for_me")
        end
      end
    end

    describe "self#generate_slug_from_parts" do
      describe "one part" do
        it "generates" do
          actual = described_class.generate_slug_from_parts(["Sigur Rós"])

          expect(actual).to eq("sigur_ros")
        end
      end

      describe "multiple parts" do
        it "generates with separator" do
          actual = described_class.generate_slug_from_parts(["Albums", "Sigur Rós", "Takk..."])

          expect(actual).to eq("albums/sigur_ros/takk")
        end
      end
    end

    describe "self#generate_slug_part" do
      it "underscores" do
        actual = described_class.generate_slug_part("iLoveMakonnen")

        expect(actual).to eq("i_love_makonnen")
      end

      it "lowercases" do
        actual = described_class.generate_slug_part("MGMT")

        expect(actual).to eq("mgmt")
      end

      it "converts non-ASCII word characters" do
        actual = described_class.generate_slug_part("Sigur Ros")

        expect(actual).to eq("sigur_ros")
      end

      it "converts &" do
        actual = described_class.generate_slug_part("Key & Peele")

        expect(actual).to eq("key_and_peele")
      end

      it "converts & in the middle of a work" do
        actual = described_class.generate_slug_part("Key&Peele")

        expect(actual).to eq("key_and_peele")
      end

      it "removes quotation marks" do
        actual = described_class.generate_slug_part('"Heroes"')

        expect(actual).to eq("heroes")
      end

      it "removes apostrophes" do
        actual = described_class.generate_slug_part("It's Like I Love You")

        expect(actual).to eq("its_like_i_love_you")
      end

      it "converts punctuation" do
        actual = described_class.generate_slug_part("Damn. I love it! Yeah")

        expect(actual).to eq("damn_i_love_it_yeah")
      end

      it "converts and collapses whitespace into underscores" do
        actual = described_class.generate_slug_part("what    is \n\n\t\t\t all this whitespace")
        expect(actual).to eq("what_is_all_this_whitespace")
      end

      it "replaces non-word characters" do
        actual = described_class.generate_slug_part("What-Am-I-Worth")

        expect(actual).to eq("what_am_i_worth")
      end

      it "does not leave leading or trailing underscores" do
        actual = described_class.generate_slug_part("_Super_Collider_")

        expect(actual).to eq("super_collider")
      end

      it "collapses underscores" do
        actual = described_class.generate_slug_part("_____Who? What?When? Where?__ why? How?____")

        expect(actual).to eq("who_what_when_where_why_how")
      end
    end

    describe "#find_duplicate_slug" do
      subject { build_minimal_instance }

      it "finds only dupe" do
        existing = create_minimal_instance
        existing.update_column(sluggable_attribute.to_sym, "some/slug")

        actual = described_class.find_duplicate_slug(subject, sluggable_attribute, "some/slug")

        expect(actual).to eq("some/slug")
      end

      it "finds indexed dupe" do
        existing = [create_minimal_instance, create_minimal_instance]

        existing[0].update_column(sluggable_attribute.to_sym, "some/slug"  )
        existing[1].update_column(sluggable_attribute.to_sym, "some/slug/v2")

        actual = described_class.find_duplicate_slug(subject, sluggable_attribute, "some/slug")

        expect(actual).to eq("some/slug/v2")
      end

      it "nil if only duplicate is self" do
        subject.save
        subject.update_column(sluggable_attribute.to_sym, "some/slug")

        actual = described_class.find_duplicate_slug(subject, sluggable_attribute, "some/slug")

        expect(actual).to eq(nil)
      end

      it "nil if no duplicate" do
        actual = described_class.find_duplicate_slug(subject, sluggable_attribute, "some/slug")

        expect(actual).to eq(nil)
      end
    end

    describe "#next_slug_index" do
      it "increments no index to 2" do
        expect(described_class.next_slug_index("some/slug")).to eq(2)
      end

      it "increments existing index by 1" do
        expect(described_class.next_slug_index("some/slug/v3")).to eq(4)
      end

      it "increments large existing index by 1" do
        expect(described_class.next_slug_index("some/slug/v1000")).to eq(1001)
      end

      it "handles indexing when base ends in digit" do
        expect(described_class.next_slug_index("some/slug_ending_in_3")).to eq(2)
      end

      it "handles indexing when base ends in /digits" do
        expect(described_class.next_slug_index("some/slug_ending_in/3")).to eq(2)
      end

      it "handles indexing when base ends in /v0" do
        expect(described_class.next_slug_index("some/slug_ending_in/v0")).to eq(2)
      end

      it "handles indexing when base ends in /v1" do
        expect(described_class.next_slug_index("some/slug_ending_in/v1")).to eq(2)
      end
    end
  end

  describe "included" do
    subject { build_minimal_instance }

    it { should validate_uniqueness_of(:slug) }
  end

  describe "instance" do
    subject { build_minimal_instance }

    describe "generate_slug" do
      context "no parts" do
        specify { expect(subject.generate_slug(sluggable_attribute.to_s  )).to eq(nil) }
        specify { expect(subject.generate_slug(sluggable_attribute.to_sym)).to eq(nil) }
      end

      context "with one part" do
        it "generates slug from parts array" do
          actual   = subject.generate_slug(sluggable_attribute, ["Hounds of Love"])
          expected = "hounds_of_love"

          expect(actual).to eq(expected)
        end

        it "generates slug from parts splat" do
          actual   = subject.generate_slug(sluggable_attribute, "Hounds of Love")
          expected = "hounds_of_love"

          expect(actual).to eq(expected)
        end

        it "generates slug from attribute string" do
          actual   = subject.generate_slug(sluggable_attribute.to_s, "Hounds of Love")
          expected = "hounds_of_love"

          expect(actual).to eq(expected)
        end

        it "generates slug from attribute symbol" do
          actual   = subject.generate_slug(sluggable_attribute.to_sym, "Hounds of Love")
          expected = "hounds_of_love"

          expect(actual).to eq(expected)
        end

        it "generates slug when dupes" do
          dupe = create_minimal_instance
          dupe.update_column(sluggable_attribute.to_sym, "hounds_of_love")

          actual   = subject.generate_slug(sluggable_attribute.to_sym, "Hounds of Love")
          expected = "hounds_of_love/v2"

          expect(actual).to eq(expected)
        end
      end

      context "with multiple parts" do
        it "generates slug from parts array" do
          actual   = subject.generate_slug(sluggable_attribute, ["Songs", "Kate Bush", "The Dreaming"])
          expected = "songs/kate_bush/the_dreaming"

          expect(actual).to eq(expected)
        end

        it "generates slug from parts splat" do
          actual   = subject.generate_slug(sluggable_attribute, "Songs", "Kate Bush", "The Dreaming")
          expected = "songs/kate_bush/the_dreaming"

          expect(actual).to eq(expected)
        end

        it "generates slug from attribute string" do
          actual   = subject.generate_slug(sluggable_attribute.to_s, "Songs", "Kate Bush", "The Dreaming")
          expected = "songs/kate_bush/the_dreaming"

          expect(actual).to eq(expected)
        end

        it "generates slug from attribute symbol" do
          actual   = subject.generate_slug(sluggable_attribute.to_sym, "Songs", "Kate Bush", "The Dreaming")
          expected = "songs/kate_bush/the_dreaming"

          expect(actual).to eq(expected)
        end

        it "generates slug when dupes" do
          dupe = create_minimal_instance
          dupe.update_column(sluggable_attribute.to_sym, "songs/kate_bush/the_dreaming")

          actual   = subject.generate_slug(sluggable_attribute.to_sym, "Songs", "Kate Bush", "The Dreaming")
          expected = "songs/kate_bush/the_dreaming/v2"

          expect(actual).to eq(expected)
        end
      end
    end

    describe "#slugify" do
      before(:each) do
        allow(subject).to receive(:"#{sluggable_attribute}=")
      end

      it "sets attribute to unique slug with one part" do
        expect(subject).to receive(:"#{sluggable_attribute}=")

        subject.slugify(sluggable_attribute, ["foo"])
      end

      it "sets attribute to unique slug with multiple parts" do
        expect(subject).to receive(:"#{sluggable_attribute}=")

        subject.slugify(sluggable_attribute, ["foo", "bar"])
      end

      it "does nothing if no parts" do
        expect(subject).to_not receive(:"#{sluggable_attribute}=")

        subject.slugify(sluggable_attribute, [])
      end
    end
  end
end
