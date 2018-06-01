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
      describe "playlistings" do
        it { is_expected.to accept_nested_attributes_for(:playlistings).allow_destroy(true) }

        pending "accepts"

        pending "rejects"

        describe "#prepare_playlistings" do
          context "new instance" do
            subject { described_class.new }

            it "builds 20 playlistings" do
              expect(subject.playlistings).to have(0).items

              subject.prepare_playlistings

              expect(subject.playlistings).to have(20).items
            end
          end

          context "saved instance with saved playlistings" do
            subject { create(:minimal_playlisting) }

            it "builds 20 more playlistings" do
              expect(subject.playlistings).to have(2).items

              subject.prepare_playlistings

              expect(subject.playlistings).to have(22).items
            end
          end
        end
      end
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
    pending "#all_creators"

    pending "#all_creator_ids"

    pending "#reorder_playlistings!"

    pending "#sluggable_parts"

    pending "#alpha_parts"
  end
end
