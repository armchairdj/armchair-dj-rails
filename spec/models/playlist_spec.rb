require "rails_helper"

RSpec.describe Playlist, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_authorable_model"

    it_behaves_like "a_displayable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let!( :first) { create(:complete_playlist, title: "First" ) }
      let!(:middle) { create(:complete_playlist, title: "Middle") }
      let!(  :last) { create(:complete_playlist, title: "Last"  ) }

      let(:ids) { [first, middle, last].map(&:id) }

      describe "self#eager" do
        subject { described_class.eager }

        it { is_expected.to eager_load(:playlistings, :works) }
      end

      describe "self#for_admin" do
        subject { described_class.for_admin.where(id: ids) }

        specify "includes all, unsorted" do
          is_expected.to match_array([first, middle, last])
        end

        it { is_expected.to eager_load(:playlistings, :works) }
      end

      describe "self#for_site" do
        subject { described_class.for_site.where(id: ids) }

        specify "includes all, sorted alphabetically" do
          is_expected.to eq([first, last, middle])
        end

        it { is_expected.to eager_load(:playlistings, :works) }
      end
    end
  end

  context "associations" do
    it { is_expected.to have_many(:playlistings) }

    it { is_expected.to have_many(:works).through(:playlistings) }

    it { is_expected.to have_many(:posts) }
  end

  context "attributes" do
    context "nested" do
      pending "for playlistings"
    end
  end

  context "validations" do
    # Nothing so far.

    context "conditional" do
      # Nothing so far.
    end

    context "custom" do
      # Nothing so far.
    end
  end

  context "hooks" do
    # Nothing so far.

    context "callbacks" do
      # Nothing so far.
    end
  end

  context "instance" do
    # Nothing so far.

    describe "private" do
      # Nothing so far.
    end
  end
end
