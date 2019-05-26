# frozen_string_literal: true

# == Schema Information
#
# Table name: creators
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  individual :boolean          default(TRUE), not null
#  name       :string           not null
#  primary    :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_creators_on_alpha       (alpha)
#  index_creators_on_individual  (individual)
#  index_creators_on_primary     (primary)
#


require "rails_helper"

RSpec.describe Creator do
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [
        :pseudonyms,        :real_names,
        :members,           :groups,
        :credits,           :contributions,
        :credited_works,    :contributed_works,
        :credited_reviews,  :contributed_reviews,
        :credited_mixtapes, :contributed_mixtapes,
        :contributed_roles
      ] }
    end

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    describe "identities" do
      describe "scopes and booleans" do
        let!(:primary) { create(:primary_creator) }
        let!(:secondary) { create(:secondary_creator) }

        describe "self#primary" do
          subject { described_class.primary }

          it { is_expected.to contain_exactly(primary) }
        end

        describe "self#secondary" do
          subject { described_class.secondary }

          it { is_expected.to contain_exactly(secondary) }
        end

        specify "#primary?" do
          expect(primary.primary?).to eq(true)
          expect(secondary.primary?).to eq(false)
        end

        specify "#secondary?" do
          expect(primary.secondary?).to eq(false)
          expect(secondary.secondary?).to eq(true)
        end
      end

      describe "collections" do
        let!(:richie) { create(:richie_hawtin) }
        let!(:robotman) { create(:robotman) }
        let!(:plastikman) { create(:plastikman) }
        let!(:fuse) { create(:fuse) }
        let!(:gas) { create(:gas) }
        let!(:identity) { create(:minimal_creator_identity, real_name: richie, pseudonym: fuse) }

        describe "self#available_pseudonyms" do
          subject { described_class.available_pseudonyms }

          it "excludes used pseudonyms and alphabetizes" do
            is_expected.to eq([gas, plastikman, robotman])
          end
        end

        describe "#available_pseudonyms" do
          subject { richie.available_pseudonyms }

          it "includes own pseudonyms, alphabetically" do
            is_expected.to eq([fuse, gas, plastikman, robotman])
          end
        end
      end
    end

    describe "memberships" do
      describe "scopes and booleans" do
        let!(:individual) { create(:individual_creator) }
        let!(:collective) { create(:collective_creator) }

        describe "self#individual" do
          subject { described_class.individual }

          it { is_expected.to eq([individual]) }
        end

        describe "self#collective" do
          subject { described_class.collective }

          it { is_expected.to eq([collective]) }
        end

        specify "#individual?" do
          expect(individual.individual?).to eq(true)
          expect(collective.individual?).to eq(false)
        end

        specify "#collective?" do
          expect(individual.collective?).to eq(false)
          expect(collective.collective?).to eq(true)
        end
      end

      describe "collections" do
        describe "self#available_members" do
          subject { described_class.available_members }

          let!(:band) { create(:fleetwood_mac) }
          let!(:stevie) { create(:stevie_nicks) }
          let!(:lindsay) { create(:lindsay_buckingham) }
          let!(:christine) { create(:christine_mcvie) }
          let!(:mick) { create(:mick_fleetwood) }
          let!(:john) { create(:john_mcvie) }
          let!(:membership) { create(:minimal_creator_membership, group: band, member: christine) }

          it "includes even used members and alphabetizes" do
            is_expected.to contain_exactly(christine, john, lindsay, mick, stevie)
          end
        end
      end
    end
  end

  describe "associations" do
    ### Credits.

    it { is_expected.to have_many(:credits).dependent(:destroy) }

    it { is_expected.to have_many(:credited_works).through(:credits) }
    it { is_expected.to have_many(:credited_reviews).through(:credited_works) }
    it { is_expected.to have_many(:credited_playlistings).through(:credited_works) }
    it { is_expected.to have_many(:credited_playlists).through(:credited_playlistings) }
    it { is_expected.to have_many(:credited_mixtapes).through(:credited_playlists) }

    ### Contributions.

    it { is_expected.to have_many(:contributions).dependent(:destroy) }

    it { is_expected.to have_many(:contributed_works).through(:contributions) }
    it { is_expected.to have_many(:contributed_reviews).through(:contributed_works) }
    it { is_expected.to have_many(:contributed_playlistings).through(:contributed_works) }
    it { is_expected.to have_many(:contributed_playlists).through(:contributed_playlistings) }
    it { is_expected.to have_many(:contributed_mixtapes).through(:contributed_playlists) }
    it { is_expected.to have_many(:contributed_roles).through(:contributions) }

    ### Identities & Memberships.

    it { is_expected.to have_many(:pseudonym_identities).dependent(:destroy) }
    it { is_expected.to have_many(:real_name_identities).dependent(:destroy) }
    it { is_expected.to have_many(:member_memberships).dependent(:destroy) }
    it { is_expected.to have_many(:group_memberships).dependent(:destroy) }

    it { is_expected.to have_many(:pseudonyms).through(:pseudonym_identities).order("creators.name") }
    it { is_expected.to have_many(:real_names).through(:real_name_identities).order("creators.name") }
    it { is_expected.to have_many(:members).through(:member_memberships).order("creators.name") }
    it { is_expected.to have_many(:groups).through(:group_memberships).order("creators.name") }
  end

  describe "attributes" do
    describe "nested" do
      describe "pseudonym_identities" do
        subject { create(:primary_creator) }

        let(:valid) { create(:secondary_creator) }
        let(:invalid) { create(:primary_creator) }

        let(:valid_params) { { "0" => { pseudonym_id:   valid.id } } }
        let(:bad_params) { { "0" => { pseudonym_id: invalid.id } } }
        let(:empty_params) { { "0" => {                          } } }

        it { is_expected.to accept_nested_attributes_for(:pseudonym_identities).allow_destroy(true) }

        describe "#prepare_pseudonym_identities" do
          it "builds 5 initially" do
            subject.prepare_pseudonym_identities

            expect(subject.pseudonym_identities).to have(5).items
          end

          it "builds 5 more" do
            subject.update!(pseudonym_identities_attributes: valid_params)

            subject.prepare_pseudonym_identities

            expect(subject.pseudonym_identities).to have(6).items
          end
        end

        specify "accepts" do
          subject.pseudonym_identities_attributes = valid_params

          expect(subject.pseudonym_identities).to have(1).items
          expect(subject.pseudonyms).to eq(Creator.none) # TODO

          subject.save!
          subject.reload

          expect(subject.pseudonym_identities).to have(1).items
          expect(subject.pseudonyms).to eq([valid])
        end

        describe "rejects if #reject_pseudonym_identity?" do
          specify "blank" do
            subject.pseudonym_identities_attributes = empty_params

            expect(subject.pseudonym_identities).to have(0).items
          end

          specify "primary" do
            subject.pseudonym_identities_attributes = bad_params

            expect(subject.pseudonym_identities).to have(0).items
          end
        end

        describe "after_save callbacks" do
          specify "#enforce_primariness" do
            subject.update!(pseudonym_identities_attributes: valid_params)

            expect(subject.pseudonym_identities).to have(1).items

            expect {
              subject.update!(primary: false)
            }.to change { Creator::Identity.count }.by(-1)

            expect(subject.reload.pseudonym_identities).to have(0).items
          end
        end
      end

      describe "real_name_identities" do
        subject { create(:secondary_creator) }

        let(:valid) { create(:primary_creator) }
        let(:invalid) { create(:secondary_creator) }

        let(:valid_params) { { "0" => { real_name_id:   valid.id } } }
        let(:bad_params) { { "0" => { real_name_id: invalid.id } } }
        let(:empty_params) { { "0" => {                          } } }

        it { is_expected.to accept_nested_attributes_for(:real_name_identities).allow_destroy(true) }

        describe "#prepare_real_name_identities" do
          it "builds 1 initially" do
            subject.prepare_real_name_identities

            expect(subject.real_name_identities).to have(1).items
          end

          it "never builds more than 1" do
            subject.update!(real_name_identities_attributes: valid_params)
            subject.prepare_real_name_identities

            expect(subject.real_name_identities).to have(1).items
          end
        end

        specify "accepts" do
          subject.real_name_identities_attributes = valid_params

          expect(subject.real_name_identities).to have(1).items
          expect(subject.real_names).to eq(Creator.none) # TODO

          subject.save!
          subject.reload

          expect(subject.real_name_identities).to have(1).items
          expect(subject.real_names).to eq([valid])
        end

        describe "rejects if #reject_real_name_identity?" do
          specify "blank" do
            subject.real_name_identities_attributes = empty_params

            expect(subject.real_name_identities).to have(0).items
          end

          specify "secondary" do
            subject.real_name_identities_attributes = bad_params

            expect(subject.real_name_identities).to have(0).items
          end
        end

        describe "after_save callbacks" do
          specify "#enforce_primariness" do
            subject.update!(real_name_identities_attributes: valid_params)

            expect(subject.real_name_identities).to have(1).items

            expect {
              subject.update!(primary: true)
            }.to change { Creator::Identity.count }.by(-1)

            expect(subject.reload.real_name_identities).to have(0).items
          end
        end
      end

      describe "member_memberships" do
        subject { create(:collective_creator) }

        let(:valid) { create(:individual_creator) }
        let(:invalid) { create(:collective_creator) }

        let(:valid_params) { { "0" => { member_id:   valid.id } } }
        let(:bad_params) { { "0" => { member_id: invalid.id } } }
        let(:empty_params) { { "0" => {                       } } }

        it { is_expected.to accept_nested_attributes_for(:member_memberships).allow_destroy(true) }

        describe "#prepare_member_memberships" do
          it "builds 5 initially" do
            subject.prepare_member_memberships

            expect(subject.member_memberships).to have(5).items
          end

          it "builds 5 more" do
            subject.update!(member_memberships_attributes: valid_params)

            subject.prepare_member_memberships

            expect(subject.member_memberships).to have(6).items
          end
        end

        specify "accepts" do
          subject.member_memberships_attributes = valid_params

          expect(subject.member_memberships).to have(1).items
          expect(subject.members).to eq(Creator.none) # TODO

          subject.save!
          subject.reload

          expect(subject.member_memberships).to have(1).items
          expect(subject.members).to eq([valid])
        end

        describe "rejects if #reject_member_membership?" do
          specify "blank" do
            subject.member_memberships_attributes = empty_params

            expect(subject.member_memberships).to have(0).items
          end

          specify "collective" do
            subject.member_memberships_attributes = bad_params

            expect(subject.member_memberships).to have(0).items
          end
        end

        describe "after_save callbacks" do
          specify "#enforce_primariness" do
            subject.update!(member_memberships_attributes: valid_params)

            expect(subject.member_memberships).to have(1).items

            expect {
              subject.update!(individual: true)
            }.to change { Creator::Membership.count }.by(-1)

            expect(subject.reload.member_memberships).to have(0).items
          end
        end
      end

      describe "group_memberships" do
        subject { create(:individual_creator) }

        let(:valid) { create(:collective_creator) }
        let(:invalid) { create(:individual_creator) }

        let(:valid_params) { { "0" => { group_id:   valid.id } } }
        let(:bad_params) { { "0" => { group_id: invalid.id } } }
        let(:empty_params) { { "0" => {                      } } }

        it { is_expected.to accept_nested_attributes_for(:group_memberships).allow_destroy(true) }

        describe "#prepare_group_memberships" do
          it "builds 5 initially" do
            subject.prepare_group_memberships

            expect(subject.group_memberships).to have(5).items
          end

          it "builds 5 more" do
            subject.update!(group_memberships_attributes: valid_params)

            subject.prepare_group_memberships

            expect(subject.group_memberships).to have(6).items
          end
        end

        specify "accepts" do
          subject.group_memberships_attributes = valid_params

          expect(subject.group_memberships).to have(1).items
          expect(subject.groups).to eq(Creator.none) # TODO

          subject.save!
          subject.reload

          expect(subject.group_memberships).to have(1).items
          expect(subject.groups).to eq([valid])
        end

        describe "rejects if #reject_group_membership?" do
          specify "blank" do
            subject.group_memberships_attributes = empty_params

            expect(subject.group_memberships).to have(0).items
          end

          specify "individual" do
            subject.group_memberships_attributes = bad_params

            expect(subject.group_memberships).to have(0).items
          end
        end

        describe "after_save callbacks" do
          specify "#enforce_primariness" do
            subject.update!(group_memberships_attributes: valid_params)

            expect(subject.group_memberships).to have(1).items

            expect {
              subject.update!(individual: false)
            }.to change { Creator::Membership.count }.by(-1)

            expect(subject.reload.group_memberships).to have(0).items
          end
        end
      end

      describe "booletania" do
        describe "class" do
          specify "self#individual_options" do
            expect(described_class.individual_options).to match_array([
              [a_string_matching(/^This is an individual/), true],
              [a_string_matching(/^This is a group/),       false]
            ])
          end

          specify "self#collective_options" do
            expect(described_class.primary_options).to match_array([
              [a_string_matching(/^This is a primary/),   true],
              [a_string_matching(/^This is a secondary/), false]
            ])
          end
        end

        describe "instance" do
          subject { build_minimal_instance }

          describe "#individual_text" do
            specify "individual" do
              subject.individual = true

              expect(subject.individual_text).to match(/^This is an individual/)
            end

            specify "collective" do
              subject.individual = false

              expect(subject.individual_text).to match(/^This is a group/)
            end
          end

          describe "#primary_text" do
            specify "primary" do
              subject.primary = true

              expect(subject.primary_text).to match(/^This is a primary/)
            end

            specify "secondary" do
              subject.primary = false

              expect(subject.primary_text).to match(/^This is a secondary/)
            end
          end
        end
      end
    end
  end

  describe "validations" do
    subject { build_minimal_instance }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to be_primary    }
    it { is_expected.to be_individual }
  end

  describe "instance" do
    describe "identities" do
      describe "#identities, #pseudonyms, #pseudonym_identities, #real_names, #real_name & #personae" do
        context "without identities" do
          let!(:kate_bush) { create(:kate_bush) }
          let!(:gas) { create(:gas) }

          specify "primary" do
            expect(kate_bush.pseudonym_identities).to eq(Creator::Identity.none)
            expect(kate_bush.pseudonyms).to eq(Creator.none)
            expect(kate_bush.personae).to eq(Creator.none)

            expect(kate_bush.real_name_identities).to eq(Creator::Identity.none)
            expect(kate_bush.real_names).to eq(Creator.none)
            expect(kate_bush.real_name).to eq(nil)
          end

          specify "secondary" do
            expect(gas.pseudonym_identities).to eq(Creator::Identity.none)
            expect(gas.pseudonyms).to eq(Creator.none)
            expect(gas.personae).to eq(Creator.none)

            expect(gas.real_name_identities).to eq(Creator::Identity.none)
            expect(gas.real_names).to eq(Creator.none)
            expect(gas.real_name).to eq(nil)
          end
        end

        context "with identities" do
          let!(:richie) { create(:richie_hawtin_with_pseudonyms) }
          let!(:plastikman) { described_class.find_by(name: "Plastikman") }
          let!(:fuse) { described_class.find_by(name: "F.U.S.E.") }

          specify "primary" do
            expect(richie.pseudonym_identities).to have(2).items
            expect(richie.pseudonyms).to eq([fuse, plastikman])
            expect(richie.personae).to eq([fuse, plastikman])

            expect(richie.real_name_identities).to eq(Creator::Identity.none)
            expect(richie.real_names).to eq(Creator.none)
            expect(richie.real_name).to eq(nil)
          end

          specify "secondary" do
            expect(plastikman.pseudonym_identities).to eq(Creator::Identity.none)
            expect(plastikman.pseudonyms).to eq([])
            expect(plastikman.personae).to eq([fuse, richie])

            expect(plastikman.real_name_identities).to have(1).items
            expect(plastikman.real_names).to eq([richie])
            expect(plastikman.real_name).to eq(richie)

            expect(fuse.pseudonym_identities).to eq(Creator::Identity.none)
            expect(fuse.pseudonyms).to eq([])
            expect(fuse.personae).to eq([plastikman, richie])

            expect(fuse.real_name_identities).to have(1).items
            expect(fuse.real_names).to eq([richie])
            expect(fuse.real_name).to eq(richie)
          end
        end
      end
    end

    describe "memberships" do
      describe "#member_memberships, #members, #group_memberships, #groups, #colleagues" do
        context "without members" do
          let!(:band) { create(:spawn) }
          let!(:solo) { create(:wolfgang_voigt) }

          specify "collective" do
            expect(band.member_memberships).to eq(Creator::Membership.none)
            expect(band.members).to eq(Creator.none)

            expect(band.group_memberships).to eq(Creator::Membership.none)
            expect(band.groups).to eq(Creator.none)
            expect(band.colleagues).to eq(Creator.none)
          end

          specify "individual" do
            expect(solo.member_memberships).to eq(Creator::Membership.none)
            expect(solo.members).to eq(Creator.none)

            expect(solo.group_memberships).to eq(Creator::Membership.none)
            expect(solo.groups).to eq(Creator.none)
            expect(solo.colleagues).to eq(Creator.none)
          end
        end

        context "with a single band" do
          let!(:band) { create(:spawn_with_members) }
          let!(:richie) { described_class.find_by(name: "Richie Hawtin") }
          let!(:fred) { described_class.find_by(name: "Fred Giannelli") }
          let!(:dan) { described_class.find_by(name: "Dan Bell") }

          specify "collective" do
            expect(band.member_memberships).to have(3).items
            expect(band.members).to eq([dan, fred, richie])

            expect(band.group_memberships).to eq(Creator::Membership.none)
            expect(band.groups).to eq(Creator.none)
            expect(band.colleagues).to eq(Creator.none)
          end

          specify "individual" do
            expect(richie.member_memberships).to eq(Creator::Membership.none)
            expect(richie.members).to eq(Creator.none)

            expect(richie.group_memberships).to have(1).items
            expect(richie.groups).to eq([band])
            expect(richie.colleagues).to eq([dan, fred])

            expect(fred.member_memberships).to eq(Creator::Membership.none)
            expect(fred.members).to eq(Creator.none)

            expect(fred.group_memberships).to have(1).items
            expect(fred.groups).to eq([band])
            expect(fred.colleagues).to eq([dan, richie])

            expect(dan.member_memberships).to eq(Creator::Membership.none)
            expect(dan.members).to eq(Creator.none)

            expect(dan.group_memberships).to have(1).items
            expect(dan.groups).to eq([band])
            expect(dan.colleagues).to eq([fred, richie])
          end
        end

        context "with multiple bands" do
          let!(:band) { create(:fleetwood_mac_with_members) }
          let!(:stevie) { described_class.find_by(name: "Stevie Nicks") }
          let!(:lindsay) { described_class.find_by(name: "Lindsay Buckingham") }
          let!(:christine) { described_class.find_by(name: "Christine McVie") }
          let!(:mick) { described_class.find_by(name: "Mick Fleetwood") }
          let!(:john) { described_class.find_by(name: "John McVie") }

          let!(:imaginary) { create(:minimal_creator, :primary, name: "Imaginary") }

          let!(:other_band) do
            other_band = create(:collective_creator, :primary, name: "Buckingham Nicks")

            create(:minimal_creator_membership, group: other_band, member: lindsay)
            create(:minimal_creator_membership, group: other_band, member: stevie)
            create(:minimal_creator_membership, group: other_band, member: imaginary)

            other_band
          end

          specify "#members" do
            expect(band.members).to eq([christine, john, lindsay, mick, stevie])
            expect(other_band.members).to eq([imaginary, lindsay, stevie])
          end

          specify "#groups" do
            expect(christine.groups).to eq([band])
            expect(imaginary.groups).to eq([other_band])
            expect(john.groups).to eq([band])
            expect(lindsay.groups).to eq([other_band, band])
            expect(mick.groups).to eq([band])
            expect(stevie.groups).to eq([other_band, band])
          end

          specify "#colleagues" do
            expect(christine.colleagues).to eq([john, lindsay, mick, stevie])
            expect(imaginary.colleagues).to eq([lindsay,       stevie])
            expect(john.colleagues).to eq([christine,                  lindsay, mick, stevie])
            expect(lindsay.colleagues).to eq([christine, imaginary, john,          mick, stevie])
            expect(mick.colleagues).to eq([christine,            john, lindsay,       stevie])
            expect(stevie.colleagues).to eq([christine, imaginary, john, lindsay, mick])
          end
        end
      end
    end

    describe "composite methods" do
      let!(:instance) { create_minimal_instance }
      let!(:created) { create(:minimal_work, :with_specific_creator, specific_creator: instance) }
      let!(:contributed) { create(:minimal_work, :with_specific_contributor, specific_contributor: instance) }
      let!(:both) { create(:minimal_work, :with_specific_creator, :with_specific_contributor, specific_creator: instance, specific_contributor: instance) }

      describe "#works" do
        subject { instance.works.ids }

        let(:expected) { [created, contributed, both].map(&:id) }

        it { is_expected.to match_array(expected) }
      end

      describe "#posts" do
        let!(:playlist) do
          create(:playlist, :with_author, title: "Title", tracks_attributes: {
            "0" => attributes_for(:playlist_track, work_id:     created.id),
            "1" => attributes_for(:playlist_track, work_id: contributed.id),
            "2" => attributes_for(:playlist_track, work_id:        both.id),
          })
        end

        let!(:credited_review) { create(:minimal_review,  work_id:      created.id) }
        let!(:contributed_review) { create(:minimal_review,  work_id:  contributed.id) }
        let!(:both_review) { create(:minimal_review,  work_id:         both.id) }
        let!(:mixtape) { create(:minimal_mixtape, playlist_id: playlist.id) }

        subject { instance.posts.ids }

        let(:expected) { [mixtape, both_review, contributed_review, credited_review].map(&:id) }

        it "finds all distinct created and contributed posts" do
          is_expected.to match_array(expected)
        end
      end
    end

    describe "#display_roles" do
      let(:instance) { create_minimal_instance }

      subject { instance.display_roles }

      context "with credits and contributions" do
        let(:editor) { create(:minimal_role, medium: "Book",   name: "Editor") }
        let(:author) { create(:minimal_role, medium: "Book",   name: "Author") }
        let(:showrunner) { create(:minimal_role, medium: "TvShow", name: "Showrunner") }
        let(:director) { create(:minimal_role, medium: "TvShow", name: "Director") }

        let(:tv_show) { create(:minimal_tv_show) }
        let(:book) { create(:minimal_book) }

        before(:each) do
          instance.credits.create(work: tv_show)
          instance.credits.create(work: book)

          instance.contributions.create(work: tv_show, role: showrunner)
          instance.contributions.create(work: tv_show, role: director)
          instance.contributions.create(work: book,    role: editor)
          instance.contributions.create(work: book,    role: author)
        end

        it "returns hash of credits and contributions sorted alphabetically and grouped by medium" do
          is_expected.to eq(
            "Book"    => ["Author",  "Creator",  "Editor"],
            "TV Show" => ["Creator", "Director", "Showrunner"]
          )
        end
      end

      context "without credits or contributions" do
        it "returns an empty hash" do
          is_expected.to eq({})
        end
      end
    end

    describe "#alpha_parts" do
      let(:instance) { build_minimal_instance }

      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.name]) }
    end
  end
end
