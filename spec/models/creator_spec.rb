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
  describe "ApplicationRecord" do
    it_behaves_like "an_application_record"

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe ":Alphabetization" do
    it_behaves_like "an_alphabetizable_model"

    describe "#alpha_parts" do
      subject(:alpha_parts) { instance.alpha_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.name]) }
    end
  end

  describe ":AttributionAssociations" do
    it { is_expected.to have_many(:attributions).dependent(:destroy) }
    it { is_expected.to have_many(:credits).dependent(:destroy) }
    it { is_expected.to have_many(:contributions).dependent(:destroy) }

    describe "#display_roles" do
      subject(:display_roles) { instance.display_roles }

      let(:instance) { create_minimal_instance }

      context "with credits and contributions" do
        let(:editor) { create(:minimal_role, medium: "Book",   name: "Editor") }
        let(:author) { create(:minimal_role, medium: "Book",   name: "Author") }
        let(:showrunner) { create(:minimal_role, medium: "TvShow", name: "Showrunner") }
        let(:director) { create(:minimal_role, medium: "TvShow", name: "Director") }

        let(:tv_show) { create(:minimal_tv_show) }
        let(:book) { create(:minimal_book) }

        before do
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

    describe "#works" do
      subject(:work_ids) { instance.works.ids }

      let!(:instance) { create_minimal_instance }
      let!(:created) { create(:minimal_work, :with_specific_creator, specific_creator: instance) }
      let!(:contributed) { create(:minimal_work, :with_specific_contributor, specific_contributor: instance) }
      let!(:both) { create(:minimal_work, :with_specific_creator, :with_specific_contributor, specific_creator: instance, specific_contributor: instance) }

      let(:expected) { [created, contributed, both].map(&:id) }

      it { is_expected.to match_array(expected) }
    end
  end

  describe ":BooletaniaIntegration" do
    let(:instance) { build_minimal_instance }

    describe ".individual_options" do
      subject { described_class.individual_options }

      it "contains the correct labels and values" do
        is_expected.to match_array([
          [a_string_matching(/^This is an individual/), true],
          [a_string_matching(/^This is a group/), false]
        ])
      end
    end

    describe ".collective_options" do
      subject { described_class.primary_options }

      it "contains the correct labels and values" do
        is_expected.to match_array([
          [a_string_matching(/^This is a primary/), true],
          [a_string_matching(/^This is a secondary/), false]
        ])
      end
    end

    describe "#individual_text" do
      it "looks up the individual option" do
        instance.individual = true

        expect(instance.individual_text).to match(/^This is an individual/)
      end

      it "looks up the collective option" do
        instance.individual = false

        expect(instance.individual_text).to match(/^This is a group/)
      end
    end

    describe "#primary_text" do
      it "looks up the primary option" do
        instance.primary = true

        expect(instance.primary_text).to match(/^This is a primary/)
      end

      it "looks up the secondary option" do
        instance.primary = false

        expect(instance.primary_text).to match(/^This is a secondary/)
      end
    end
  end

  describe ":CreditedAssociations" do
    it { is_expected.to have_many(:credited_works).through(:credits) }
    it { is_expected.to have_many(:credited_playlistings).through(:credited_works) }
    it { is_expected.to have_many(:credited_playlists).through(:credited_playlistings) }
  end

  describe ":ContributedAssociations" do
    it { is_expected.to have_many(:contributed_works).through(:contributions) }
    it { is_expected.to have_many(:contributed_playlistings).through(:contributed_works) }
    it { is_expected.to have_many(:contributed_playlists).through(:contributed_playlistings) }
    it { is_expected.to have_many(:contributed_roles).through(:contributions) }
  end

  describe ":Editing" do
    describe "#prepare_for_editing" do
      it "builds nested attributes" do
        instance = build_minimal_instance

        expect(instance).to receive(:prepare_group_memberships)
        expect(instance).to receive(:prepare_member_memberships)
        expect(instance).to receive(:prepare_pseudonym_identities)
        expect(instance).to receive(:prepare_real_name_identities)

        instance.prepare_for_editing
      end
    end

    describe "#prepare_group_memberships" do
      it "builds 5 initially" do
        instance = create(:individual_creator)

        instance.prepare_group_memberships

        expect(instance.group_memberships).to have(5).items
      end

      it "builds 5 more" do
        instance = create(:individual_creator, :with_group)

        instance.prepare_group_memberships

        expect(instance.group_memberships).to have(6).items
      end
    end

    describe "#prepare_member_memberships" do
      it "builds 5 initially" do
        instance = create(:collective_creator)

        instance.prepare_member_memberships

        expect(instance.member_memberships).to have(5).items
      end

      it "builds 5 more" do
        instance = create(:collective_creator, :with_member)

        instance.prepare_member_memberships

        expect(instance.member_memberships).to have(6).items
      end
    end

    describe "#prepare_pseudonym_identities" do
      it "builds 5 initially" do
        instance = create(:primary_creator)

        instance.prepare_pseudonym_identities

        expect(instance.pseudonym_identities).to have(5).items
      end

      it "builds 5 more" do
        instance = create(:primary_creator, :with_pseudonym)

        instance.prepare_pseudonym_identities

        expect(instance.pseudonym_identities).to have(6).items
      end
    end

    describe "#prepare_real_name_identities" do
      it "builds 1 initially" do
        instance = create(:secondary_creator)

        instance.prepare_real_name_identities

        expect(instance.real_name_identities).to have(1).items
      end

      it "never builds more than 1" do
        instance = create(:secondary_creator, :with_real_name)

        instance.prepare_real_name_identities

        expect(instance.real_name_identities).to have(1).items
      end
    end
  end

  describe ":GinsuIntegration" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [] }
      let(:show_loads) do
        [
          :pseudonyms,        :real_names,
          :members,           :groups,
          :credits,           :contributions,
          :credited_works,    :contributed_works,
          :credited_reviews,  :contributed_reviews,
          :credited_mixtapes, :contributed_mixtapes,
          :contributed_roles
        ]
      end
    end
  end

  describe ":NameAttribute" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe ":PostAssociations" do
    it { is_expected.to have_many(:contributed_reviews).through(:contributed_works) }
    it { is_expected.to have_many(:contributed_mixtapes).through(:contributed_playlists) }

    it { is_expected.to have_many(:credited_reviews).through(:credited_works) }
    it { is_expected.to have_many(:credited_mixtapes).through(:credited_playlists) }

    describe "#posts and #post_ids" do
      subject(:post_ids) { instance.posts.ids }

      let!(:instance) { create_minimal_instance }
      let!(:created) { create(:minimal_work, :with_specific_creator, specific_creator: instance) }
      let!(:contributed) { create(:minimal_work, :with_specific_contributor, specific_contributor: instance) }
      let!(:both) { create(:minimal_work, :with_specific_creator, :with_specific_contributor, specific_creator: instance, specific_contributor: instance) }

      let!(:playlist) do
        create(:playlist, :with_author, title: "Title", tracks_attributes: {
          "0" => attributes_for(:playlist_track, work_id: created.id),
          "1" => attributes_for(:playlist_track, work_id: contributed.id),
          "2" => attributes_for(:playlist_track, work_id: both.id)
        })
      end

      let!(:credited_review) { create(:minimal_review, work_id: created.id) }
      let!(:contributed_review) { create(:minimal_review, work_id: contributed.id) }
      let!(:both_review) { create(:minimal_review, work_id: both.id) }
      let!(:mixtape) { create(:minimal_mixtape, playlist_id: playlist.id) }

      let(:expected) { [mixtape, both_review, contributed_review, credited_review] }

      it "finds all distinct created and contributed posts" do
        expect(instance.post_ids).to match_array(expected.map(&:id))
        expect(instance.posts).to match_array(expected)
      end
    end
  end

  describe ":IndividualAttribute" do
    it "defaults to true" do
      expect(described_class.new).to be_individual
    end

    describe "#enforce_individuality" do
      context "when individual creator becomes collective" do
        let(:instance) { create(:individual_creator, :with_group) }

        it "clears group_memberships" do
          expect { instance.update!(individual: false) }.
            to change { instance.group_memberships.count }.by(-1)
        end
      end

      context "when collective creator becomes individual" do
        let(:instance) { create(:collective_creator, :with_member) }

        it "clears member_memberships" do
          expect { instance.update!(individual: true) }.
            to change { instance.member_memberships.count }.by(-1)
        end
      end
    end

    describe "booleans and boolean scopes" do
      let!(:individual) { create(:individual_creator) }
      let!(:collective) { create(:collective_creator) }

      describe ".individual" do
        subject(:association) { described_class.individual }

        it { is_expected.to eq([individual]) }
      end

      describe ".collective" do
        subject(:association) { described_class.collective }

        it { is_expected.to eq([collective]) }
      end

      specify "#individual? and solo? return the correct booleans" do
        expect(individual.individual?).to eq(true)
        expect(individual.solo?).to eq(true)

        expect(collective.individual?).to eq(false)
        expect(collective.solo?).to eq(false)
      end

      specify "#collective? and #group? return the correct booleans" do
        expect(individual.collective?).to eq(false)
        expect(individual.group?).to eq(false)

        expect(collective.collective?).to eq(true)
        expect(collective.group?).to eq(true)
      end
    end

    describe "availability scopes" do
      pending ".available_groups"

      describe ".available_members" do
        subject(:association) { described_class.available_members }

        let!(:fleetwood_mac) { create(:fleetwood_mac) }
        let!(:stevie) { create(:stevie_nicks) }
        let!(:lindsay) { create(:lindsay_buckingham) }
        let!(:christine) { create(:christine_mcvie) }
        let!(:mick) { create(:mick_fleetwood) }
        let!(:john) { create(:john_mcvie) }
        let!(:membership) { create(:minimal_creator_membership, group: fleetwood_mac, member: christine) }

        it "includes even used members and alphabetizes" do
          is_expected.to contain_exactly(christine, john, lindsay, mick, stevie)
        end
      end
    end

    pending "#membership_type"
  end

  describe ":MembershipAssociations" do
    it { is_expected.to have_many(:group_memberships).dependent(:destroy) }
    it { is_expected.to have_many(:member_memberships).dependent(:destroy) }

    it { is_expected.to have_many(:groups).through(:group_memberships).order("creators.name") }
    it { is_expected.to have_many(:members).through(:member_memberships).order("creators.name") }

    describe "nested attributes for member_memberships" do
      subject(:instance) { create(:collective_creator) }

      it { is_expected.to accept_nested_attributes_for(:member_memberships).allow_destroy(true) }

      it "accepts if individual" do
        valid = create(:individual_creator)

        instance.member_memberships_attributes = { "0" => { member_id: valid.id } }

        expect(instance.member_memberships).to have(1).items
        expect(instance.members).to eq(described_class.none) # TODO

        instance.save!
        instance.reload

        expect(instance.member_memberships).to have(1).items
        expect(instance.members).to eq([valid])
      end

      it "rejects if collective" do
        invalid = create(:collective_creator)

        instance.member_memberships_attributes = { "0" => { member_id: invalid.id } }

        expect(instance.member_memberships).to have(0).items
      end

      it "rejects if blank" do
        instance.member_memberships_attributes = { "0" => {} }

        expect(instance.member_memberships).to have(0).items
      end
    end

    describe "nested attributes for group_memberships" do
      subject(:instance) { create(:individual_creator) }

      it { is_expected.to accept_nested_attributes_for(:group_memberships).allow_destroy(true) }

      it "accepts if collective" do
        valid = create(:collective_creator)

        instance.group_memberships_attributes = { "0" => { group_id: valid.id } }

        expect(instance.group_memberships).to have(1).items
        expect(instance.groups).to eq(described_class.none) # TODO

        instance.save!
        instance.reload

        expect(instance.group_memberships).to have(1).items
        expect(instance.groups).to eq([valid])
      end

      it "rejects if individual" do
        invalid = create(:individual_creator)

        instance.group_memberships_attributes = { "0" => { group_id: invalid.id } }

        expect(instance.group_memberships).to have(0).items
      end

      it "rejects if blank" do
        instance.group_memberships_attributes = { "0" => {} }

        expect(instance.group_memberships).to have(0).items
      end
    end

    describe "unlinked solo creator" do
      let(:instance) { create(:wolfgang_voigt) }

      specify "has no membership associations" do
        expect(instance.member_memberships).to eq(described_class::Membership.none)
        expect(instance.members).to eq(described_class.none)

        expect(instance.group_memberships).to eq(described_class::Membership.none)
        expect(instance.groups).to eq(described_class.none)
        expect(instance.colleagues).to eq(described_class.none)
      end
    end

    describe "unlinked group creator" do
      let!(:instance) { create(:spawn) }

      specify "has no membership associations" do
        expect(instance.member_memberships).to eq(described_class::Membership.none)
        expect(instance.members).to eq(described_class.none)

        expect(instance.group_memberships).to eq(described_class::Membership.none)
        expect(instance.groups).to eq(described_class.none)
        expect(instance.colleagues).to eq(described_class.none)
      end
    end

    describe "linked solo and group creators" do
      let!(:spawn) { create(:spawn_with_members) }
      let!(:richie) { described_class.find_by(name: "Richie Hawtin") }
      let!(:fred) { described_class.find_by(name: "Fred Giannelli") }
      let!(:dan) { described_class.find_by(name: "Dan Bell") }

      it "has the correct membership associations for the group and members" do
        expect(spawn.member_memberships).to have(3).items
        expect(spawn.members).to eq([dan, fred, richie])

        expect(spawn.group_memberships).to eq(described_class::Membership.none)
        expect(spawn.groups).to eq(described_class.none)
        expect(spawn.colleagues).to eq(described_class.none)

        expect(richie.group_memberships).to have(1).items
        expect(richie.groups).to eq([spawn])
        expect(richie.colleagues).to eq([dan, fred])

        expect(richie.member_memberships).to eq(described_class::Membership.none)
        expect(richie.members).to eq(described_class.none)

        expect(fred.group_memberships).to have(1).items
        expect(fred.groups).to eq([spawn])
        expect(fred.colleagues).to eq([dan, richie])

        expect(fred.member_memberships).to eq(described_class::Membership.none)
        expect(fred.members).to eq(described_class.none)

        expect(dan.group_memberships).to have(1).items
        expect(dan.groups).to eq([spawn])
        expect(dan.colleagues).to eq([fred, richie])

        expect(dan.member_memberships).to eq(described_class::Membership.none)
        expect(dan.members).to eq(described_class.none)
      end
    end

    describe "complex linked solo and group creators" do
      let!(:fleetwood_mac) { create(:fleetwood_mac_with_members) }

      let!(:stevie) { described_class.find_by(name: "Stevie Nicks") }
      let!(:lindsay) { described_class.find_by(name: "Lindsay Buckingham") }
      let!(:christine) { described_class.find_by(name: "Christine McVie") }
      let!(:mick) { described_class.find_by(name: "Mick Fleetwood") }
      let!(:john) { described_class.find_by(name: "John McVie") }

      let!(:tom) { create(:minimal_creator, :primary, name: "Tom Petty") }

      let!(:nicks_petty) do
        memo = create(:collective_creator, :primary, name: "Nicks & Petty")
        create(:minimal_creator_membership, group: memo, member: stevie)
        create(:minimal_creator_membership, group: memo, member: tom)
        memo
      end

      let!(:buckingham_nicks) do
        memo = create(:collective_creator, :primary, name: "Buckingham Nicks")
        create(:minimal_creator_membership, group: memo, member: lindsay)
        create(:minimal_creator_membership, group: memo, member: stevie)
        memo
      end

      let!(:buckingham_mcvie) do
        memo = create(:collective_creator, :primary, name: "Buckingham McVie")
        create(:minimal_creator_membership, group: memo, member: lindsay)
        create(:minimal_creator_membership, group: memo, member: christine)
        memo
      end

      it "has the correct membership associations for the groups and members" do
        expect(fleetwood_mac.members).to eq([christine, john, lindsay, mick, stevie])
        expect(nicks_petty.members).to eq([stevie, tom])
        expect(buckingham_nicks.members).to eq([lindsay, stevie])
        expect(buckingham_mcvie.members).to eq([christine, lindsay])

        expect(christine.groups).to eq([buckingham_mcvie, fleetwood_mac])
        expect(christine.colleagues).to eq([john, lindsay, mick, stevie])

        expect(john.groups).to eq([fleetwood_mac])
        expect(john.colleagues).to eq([christine, lindsay, mick, stevie])

        expect(lindsay.groups).to eq([buckingham_mcvie, buckingham_nicks, fleetwood_mac])
        expect(lindsay.colleagues).to eq([christine, john, mick, stevie])

        expect(mick.groups).to eq([fleetwood_mac])
        expect(mick.colleagues).to eq([christine, john, lindsay, stevie])

        expect(stevie.groups).to eq([buckingham_nicks, fleetwood_mac, nicks_petty])
        expect(stevie.colleagues).to eq([christine, john, lindsay, mick, tom])

        expect(tom.groups).to eq([nicks_petty])
        expect(tom.colleagues).to eq([stevie])
      end
    end
  end

  describe ":PrimaryAttribute" do
    it "defaults to true" do
      expect(described_class.new).to be_primary
    end

    describe "#enforce_primariness" do
      context "when primary creator becomes secondary" do
        let(:instance) { create(:primary_creator, :with_pseudonym) }

        it "clears pseudonym_identities" do
          expect { instance.update!(primary: false) }.
            to change { instance.pseudonym_identities.count }.by(-1)
        end
      end

      context "when secondary creator becomes primary" do
        let(:instance) { create(:secondary_creator, :with_real_name) }

        it "clears real_name_identities" do
          expect { instance.update!(primary: true) }.
            to change { instance.real_name_identities.count }.by(-1)
        end
      end
    end

    describe "booleans and boolean scopes" do
      let!(:primary) { create(:primary_creator) }
      let!(:secondary) { create(:secondary_creator) }

      describe ".primary" do
        subject(:association) { described_class.primary }

        it { is_expected.to contain_exactly(primary) }
      end

      describe ".secondary" do
        subject(:association) { described_class.secondary }

        it { is_expected.to contain_exactly(secondary) }
      end

      specify "#primary? and #real_name? return the correct boolean" do
        expect(primary.primary?).to eq(true)
        expect(primary.real_name?).to eq(true)

        expect(secondary.primary?).to eq(false)
        expect(secondary.real_name?).to eq(false)
      end

      specify "#secondary? and #pseudonym? return the correct boolean" do
        expect(primary.secondary?).to eq(false)
        expect(primary.pseudonym?).to eq(false)

        expect(secondary.secondary?).to eq(true)
        expect(secondary.pseudonym?).to eq(true)
      end
    end

    describe "availability scopes" do
      let!(:richie) { create(:richie_hawtin) }
      let!(:robotman) { create(:robotman) }
      let!(:plastikman) { create(:plastikman) }
      let!(:fuse) { create(:fuse) }
      let!(:gas) { create(:gas) }
      let!(:identity) { create(:minimal_creator_identity, real_name: richie, pseudonym: fuse) }

      describe ".available_pseudonyms" do
        subject(:available_pseudonyms) { described_class.available_pseudonyms }

        it "excludes used pseudonyms and alphabetizes" do
          is_expected.to eq([gas, plastikman, robotman])
        end
      end

      describe "#available_pseudonyms" do
        subject(:available_pseudonyms) { richie.available_pseudonyms }

        it "includes own pseudonyms, alphabetically" do
          is_expected.to eq([fuse, gas, plastikman, robotman])
        end
      end
    end
  end

  describe ":IdentityAssociations" do
    it { is_expected.to have_many(:pseudonym_identities).dependent(:destroy) }
    it { is_expected.to have_many(:pseudonyms).through(:pseudonym_identities).order("creators.name") }

    it { is_expected.to have_many(:real_name_identities).dependent(:destroy) }
    it { is_expected.to have_many(:real_names).through(:real_name_identities).order("creators.name") }

    describe "nested attributes for real_name_identities" do
      subject(:instance) { create(:secondary_creator) }

      it { is_expected.to accept_nested_attributes_for(:real_name_identities).allow_destroy(true) }

      it "accepts if primary" do
        valid = create(:primary_creator)

        instance.real_name_identities_attributes = { "0" => { real_name_id: valid.id } }

        expect(instance.real_name_identities).to have(1).items
        expect(instance.real_names).to eq(described_class.none) # TODO

        instance.save!
        instance.reload

        expect(instance.real_name_identities).to have(1).items
        expect(instance.real_names).to eq([valid])
      end

      it "rejects if secondary" do
        invalid = create(:secondary_creator)

        instance.real_name_identities_attributes = { "0" => { real_name_id: invalid.id } }

        expect(instance.real_name_identities).to have(0).items
      end

      it "rejects if blank" do
        instance.real_name_identities_attributes = { "0" => {} }

        expect(instance.real_name_identities).to have(0).items
      end
    end

    describe "nested attributes for pseudonym_identities" do
      subject(:instance) { create(:primary_creator) }

      it { is_expected.to accept_nested_attributes_for(:pseudonym_identities).allow_destroy(true) }

      it "accepts if secondary" do
        valid = create(:secondary_creator)

        instance.pseudonym_identities_attributes = { "0" => { pseudonym_id: valid.id } }

        expect(instance.pseudonym_identities).to have(1).items
        expect(instance.pseudonyms).to eq(described_class.none) # TODO

        instance.save!
        instance.reload

        expect(instance.pseudonym_identities).to have(1).items
        expect(instance.pseudonyms).to eq([valid])
      end

      it "rejects if primary" do
        invalid = create(:primary_creator)

        instance.pseudonym_identities_attributes = { "0" => { pseudonym_id: invalid.id } }

        expect(instance.pseudonym_identities).to have(0).items
      end

      it "rejects if blank" do
        instance.pseudonym_identities_attributes = { "0" => {} }

        expect(instance.pseudonym_identities).to have(0).items
      end
    end

    describe "unlinked primary creator" do
      let(:instance) { create(:kate_bush) }

      it "has no identity associations" do
        expect(instance.pseudonym_identities).to eq(described_class::Identity.none)
        expect(instance.pseudonyms).to eq(described_class.none)
        expect(instance.personae).to eq(described_class.none)

        expect(instance.real_name_identities).to eq(described_class::Identity.none)
        expect(instance.real_names).to eq(described_class.none)
        expect(instance.real_name).to eq(nil)
      end
    end

    describe "unlinked secondary creator" do
      let(:instance) { create(:gas) }

      it "has no identity associations" do
        expect(instance.pseudonym_identities).to eq(described_class::Identity.none)
        expect(instance.pseudonyms).to eq(described_class.none)
        expect(instance.personae).to eq(described_class.none)

        expect(instance.real_name_identities).to eq(described_class::Identity.none)
        expect(instance.real_names).to eq(described_class.none)
        expect(instance.real_name).to eq(nil)
      end
    end

    describe "linked primary and secondary creators" do
      let!(:richie) { create(:richie_hawtin_with_pseudonyms) }
      let!(:plastikman) { described_class.find_by(name: "Plastikman") }
      let!(:fuse) { described_class.find_by(name: "F.U.S.E.") }

      specify "have the correct identity associations for the primary" do
        expect(richie.pseudonym_identities).to have(2).items
        expect(richie.pseudonyms).to eq([fuse, plastikman])
        expect(richie.personae).to eq([fuse, plastikman])

        expect(richie.real_name_identities).to eq(described_class::Identity.none)
        expect(richie.real_names).to eq(described_class.none)
        expect(richie.real_name).to eq(nil)
      end

      specify "have the correct idenity associations for the secondaries" do
        expect(plastikman.real_name_identities).to have(1).items
        expect(plastikman.real_names).to eq([richie])
        expect(plastikman.real_name).to eq(richie)

        expect(plastikman.pseudonym_identities).to eq(described_class::Identity.none)
        expect(plastikman.pseudonyms).to eq([])
        expect(plastikman.personae).to eq([fuse, richie])

        expect(fuse.real_name_identities).to have(1).items
        expect(fuse.real_names).to eq([richie])
        expect(fuse.real_name).to eq(richie)

        expect(fuse.pseudonym_identities).to eq(described_class::Identity.none)
        expect(fuse.pseudonyms).to eq([])
        expect(fuse.personae).to eq([plastikman, richie])
      end
    end
  end
end
