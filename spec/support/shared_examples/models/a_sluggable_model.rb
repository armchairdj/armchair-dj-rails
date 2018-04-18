require "rails_helper"

RSpec.shared_examples "a sluggable model" do |sluggable_attribute|
  describe "class" do
    describe "#generate_unique_slug" do
      subject { build_minimal_instance }

      it "generates slug for unique base" do
        actual   = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, ["Foo Bar", "BAT"])
        expected = "foo_bar/bat"

        expect(actual).to eq(expected)
      end

      it "adds index for non-unique base" do
        existing = create_minimal_instance
        existing.update_column(sluggable_attribute.to_sym, "foo_bar/bat")

        actual   = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, ["Foo Bar", "BAT"])
        expected = "foo_bar/bat/1"

        expect(actual).to eq(expected)
      end

      it "does not add index for self" do
        subject.save
        subject.update_column(sluggable_attribute.to_sym, "foo_bar/bat")

        actual   = described_class.generate_unique_slug(subject, sluggable_attribute.to_sym, ["Foo Bar", "BAT"])
        expected = "foo_bar/bat"

        expect(actual).to eq(expected)
      end
    end

    describe "self#generate_slug_from_parts" do
      describe "one part" do
        it "generates" do
          actual   = described_class.generate_slug_from_parts(["Sigur Rós"])
          expected = "sigur_rós"

          expect(actual).to eq(expected)
        end
      end

      describe "multiple parts" do
        it "generates with separator" do
          actual   = described_class.generate_slug_from_parts(["Albums", "Sigur Rós", "Takk..."])
          expected = "albums/sigur_rós/takk"

          expect(actual).to eq(expected)
        end
      end
    end

    describe "self#generate_slug_part" do
      it "underscores and lowercases" do
        actual   = described_class.generate_slug_part("Ray of Light")
        expected = "ray_of_light"

        expect(actual).to eq(expected)
      end

      it "replaces &" do
        actual   = described_class.generate_slug_part("Key & Peele")
        expected = "key_and_peele"

        expect(actual).to eq(expected)
      end

      it "replaces & in the middle of a work" do
        actual   = described_class.generate_slug_part("Key&Peele")
        expected = "key_and_peele"

        expect(actual).to eq(expected)
      end

      it "replaces punctuation" do
        actual   = described_class.generate_slug_part("Damn. I love it! Yeah")
        expected = "damn_i_love_it_yeah"

        expect(actual).to eq(expected)
      end

      it "replaces and collapses whitespace" do
        actual   = described_class.generate_slug_part("what    is \n\n\t\t\t all this whitespace")
        expected = "what_is_all_this_whitespace"

        expect(actual).to eq(expected)
      end

      it "replaces non-word characters" do
        actual   = described_class.generate_slug_part("What-Am-I-Worth")
        expected = "what_am_i_worth"

        expect(actual).to eq(expected)
      end

      it "does not leave leading or trailing underscores" do
        actual   = described_class.generate_slug_part("_Super_Collider_")
        expected = "super_collider"

        expect(actual).to eq(expected)
      end

      it "collapses underscores" do
        actual   = described_class.generate_slug_part("_____Who? What? Where?__When? How?____")
        expected = "who_what_where_when_how"

        expect(actual).to eq(expected)
      end

      it "leaves non-ASCII word characters" do
        actual   = described_class.generate_slug_part("Sigur Rós")
        expected = "sigur_rós"

        expect(actual).to eq(expected)
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
        existing[1].update_column(sluggable_attribute.to_sym, "some/slug/1")

        actual = described_class.find_duplicate_slug(subject, sluggable_attribute, "some/slug")

        expect(actual).to eq("some/slug/1")
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
      it "increments no index to 1" do
        expect(described_class.next_slug_index("some/slug")).to eq(1)
      end

      it "increments existing index by 1" do
        expect(described_class.next_slug_index("some/slug/3")).to eq(4)
      end

      it "handles indexing when base ends in digit" do
        expect(described_class.next_slug_index("some/slug_ending_in_3")).to eq(1)
      end
    end
  end

  describe "included" do
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
          expected = "hounds_of_love/1"

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
          expected = "songs/kate_bush/the_dreaming/1"

          expect(actual).to eq(expected)
        end
      end
    end

    describe "#slugify" do
      it "sets attribute to unique slug with one part" do

      end

      it "sets attribute to unique slug with multiple parts" do

      end

      it "does nothing if no parts" do

      end
    end
  end
end
