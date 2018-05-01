# frozen_string_literal: true

require "rails_helper"

RSpec.describe Creator, type: :model do
  context "constants" do
    specify { expect(described_class).to have_constant(:MAX_PSEUDONYMS_AT_ONCE ) }
    specify { expect(described_class).to have_constant(:MAX_REAL_NAMES         ) }
    specify { expect(described_class).to have_constant(:MAX_MEMBERS_AT_ONCE    ) }
    specify { expect(described_class).to have_constant(:MAX_GROUPS_AT_ONCE     ) }
  end

  context "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "a_summarizable_model"

    it_behaves_like "a_viewable_model"

    it_behaves_like "an_atomically_validatable_model", { name: nil } do
      subject { create(:minimal_creator) }
    end
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let!(:zorro  ) { create(:creator, name: "Zorro the Gay Blade") }
      let!(:amy_1  ) { create(:creator, name: "amy winehouse") }
      let!(:kate   ) { create(:creator, name: "Kate Bush") }
      let!(:amy_2  ) { create(:creator, name: "Amy Wino") }
      let!(:anthony) { create(:creator, name: "Anthony Childs") }
      let!(:zero   ) { create(:creator, name: "0773") }

      before(:each) do
        create(:review_without_work, :published, "work_attributes" => attributes_for(:work_without_credits).merge({
          "credits_attributes" => { "0" => { "creator_id" => amy_1.id } }
        }))

        create(:review_without_work, :published, "work_attributes" => attributes_for(:work_without_credits).merge({
          "credits_attributes" => { "0" => { "creator_id" => zero.id } }
        }))

        create(:review_without_work, :draft, "work_attributes" => attributes_for(:work_without_credits).merge({
          "credits_attributes" => { "0" => { "creator_id" => kate.id } }
        }))
      end

      describe "self#for_admin" do
        specify "includes all creators, unsorted" do
          expect(described_class.for_admin).to match_array([
            amy_2, anthony, kate, zorro, zero, amy_1
          ])
        end
      end

      describe "self#for_site" do
        specify "includes only creators with published posts, sorted alphabetically" do
          expect(described_class.for_site).to eq([zero, amy_1])
        end
      end

      describe "self#alpha" do
        specify "sorts alphabetically" do
          expect(described_class.alpha).to eq([
            zero, amy_1, amy_2, anthony, kate, zorro
          ])
        end
      end

      pending "eager"
    end

    context "identities" do
      context "scopes and booleans" do
        let!(  :primary) { create(  :primary_creator) }
        let!(:secondary) { create(:secondary_creator) }

        specify "self#primary" do
          expect(described_class.primary).to eq([primary])
        end

        specify "self#secondary" do
          expect(described_class.secondary).to eq([secondary])
        end

        specify "#primary?" do
          expect(  primary.primary?).to eq(true)
          expect(secondary.primary?).to eq(false)
        end

        specify "#secondary?" do
          expect(  primary.secondary?).to eq(false)
          expect(secondary.secondary?).to eq(true)
        end
      end

      context "collections" do
        let!(    :richie) { create(:richie_hawtin) }
        let!(  :robotman) { create(:robotman     ) }
        let!(:plastikman) { create(:plastikman   ) }
        let!(      :fuse) { create(:fuse         ) }
        let!(       :gas) { create(:gas          ) }
        let!(  :identity) { create(:minimal_identity, real_name: richie, pseudonym: fuse) }

        describe "self#available_pseudonyms" do
          specify "excludes used pseudonyms and alphabetizes" do
             expect(described_class.available_pseudonyms).to eq([
               gas,
               plastikman,
               robotman
             ])
          end
        end

        describe "#available_pseudonyms" do
          specify "includes own pseudonyms" do
             expect(richie.available_pseudonyms).to eq([
               fuse,
               gas,
               plastikman,
               robotman
             ])
          end
        end
      end
    end

    context "memberships" do
      context "scopes and booleans" do
        let!(:individual) { create(:individual_creator) }
        let!(:collective) { create(:collective_creator) }

        specify "self#individual" do
          expect(described_class.individual).to eq([individual])
        end

        specify "self#collective" do
          expect(described_class.collective).to eq([collective])
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

      context "collections" do
        describe "self#available_members" do
          let!(      :band) { create(:fleetwood_mac     ) }
          let!(    :stevie) { create(:stevie_nicks      ) }
          let!(   :lindsay) { create(:lindsay_buckingham) }
          let!( :christine) { create(:christine_mcvie   ) }
          let!(      :mick) { create(:mick_fleetwood    ) }
          let!(      :john) { create(:john_mcvie        ) }
          let!(:membership) { create(:minimal_membership, group: band, member: christine) }

          specify "includes even used members and alphabetizes" do
             expect(described_class.available_members).to eq([
               christine,
               john,
               lindsay,
               mick,
               stevie,
             ])
          end
        end
      end
    end
  end

  context "associations" do
    it { should have_many(:credits) }
    it { should have_many(:works).through(:credits) }
    it { should have_many(:posts).through(:works  ) }

    it { should have_many(:contributions) }
    it { should have_many(:contributed_works).through(:contributions    ) }
    it { should have_many(:contributed_posts).through(:contributed_works) }

    it { should have_many(:pseudonym_identities) }
    it { should have_many(:real_name_identities) }

    it { should have_many(:pseudonyms).through(:pseudonym_identities).order("creators.name") }
    it { should have_many(:real_names).through(:real_name_identities).order("creators.name") }

    it { should have_many(:member_memberships) }
    it { should have_many( :group_memberships) }

    it { should have_many(:members).through(:member_memberships).order("creators.name") }
    it { should have_many( :groups).through( :group_memberships).order("creators.name") }
  end

  context "attributes" do
    context "nested" do
      context "pseudonym_identities" do
        subject { create(:primary_creator) }

        let(  :valid) { create(:secondary_creator) }
        let(:invalid) { create(:primary_creator  ) }

        let(  :valid_params) { { "0" => { pseudonym_id:   valid.id } } }
        let(:invalid_params) { { "0" => { pseudonym_id: invalid.id } } }
        let(  :empty_params) { { "0" => {                          } } }

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
          expect(subject.pseudonyms          ).to eq(Creator.none) # TODO

          subject.save!
          subject.reload

          expect(subject.pseudonym_identities).to have(1).items
          expect(subject.pseudonyms          ).to eq([valid])
        end

        describe "rejects if #blank_or_primary?" do
          specify "blank" do
            subject.pseudonym_identities_attributes = empty_params

            expect(subject.pseudonym_identities).to have(0).items
          end

          specify "primary" do
            subject.pseudonym_identities_attributes = invalid_params

            expect(subject.pseudonym_identities).to have(0).items
          end
        end

        describe "after_save callbacks" do
          specify "#enforce_primariness" do
            subject.update!(pseudonym_identities_attributes: valid_params)

            expect(subject.pseudonym_identities).to have(1).items

            expect {
              subject.update!(primary: false)
            }.to change { Identity.count }.by(-1)

            expect(subject.reload.pseudonym_identities).to have(0).items
          end
        end

        describe "allow_destroy" do
          it "destroys the identity but not the pseudonym" do
            subject.update!(pseudonym_identities_attributes: valid_params)

            expect(subject.pseudonyms).to eq([valid])

            subject.pseudonym_identities.destroy_all

            subject.reload

            expect(subject.pseudonym_identities).to eq([])
            expect(subject.pseudonyms).to eq([])

            expect(valid.reload).to eq(valid)
          end
        end
      end

      context "real_name_identities" do
        subject { create(:secondary_creator) }

        let(  :valid) { create(:primary_creator  ) }
        let(:invalid) { create(:secondary_creator) }

        let(  :valid_params) { { "0" => { real_name_id:   valid.id } } }
        let(:invalid_params) { { "0" => { real_name_id: invalid.id } } }
        let(  :empty_params) { { "0" => {                          } } }

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
          expect(subject.real_names          ).to eq(Creator.none) # TODO

          subject.save!
          subject.reload

          expect(subject.real_name_identities).to have(1).items
          expect(subject.real_names          ).to eq([valid])
        end

        describe "rejects if #blank_or_secondary?" do
          specify "blank" do
            subject.real_name_identities_attributes = empty_params

            expect(subject.real_name_identities).to have(0).items
          end

          specify "secondary" do
            subject.real_name_identities_attributes = invalid_params

            expect(subject.real_name_identities).to have(0).items
          end
        end

        describe "after_save callbacks" do
          specify "#enforce_primariness" do
            subject.update!(real_name_identities_attributes: valid_params)

            expect(subject.real_name_identities).to have(1).items

            expect {
              subject.update!(primary: true)
            }.to change { Identity.count }.by(-1)

            expect(subject.reload.real_name_identities).to have(0).items
          end
        end

        describe "allow_destroy" do
          it "destroys the identity but not the real_name" do
            subject.update!(real_name_identities_attributes: valid_params)

            expect(subject.real_names).to eq([valid])

            subject.real_name_identities.destroy_all

            subject.reload

            expect(subject.real_name_identities).to eq([])
            expect(subject.real_names          ).to eq([])

            expect(valid.reload).to eq(valid)
          end
        end
      end

      context "member_memberships" do
        subject { create(:collective_creator) }

        let(  :valid) { create(:individual_creator) }
        let(:invalid) { create(:collective_creator) }

        let(  :valid_params) { { "0" => { member_id:   valid.id } } }
        let(:invalid_params) { { "0" => { member_id: invalid.id } } }
        let(  :empty_params) { { "0" => {                       } } }

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
          expect(subject.members           ).to eq(Creator.none) # TODO

          subject.save!
          subject.reload

          expect(subject.member_memberships).to have(1).items
          expect(subject.members           ).to eq([valid])
        end

        describe "rejects if #blank_or_collective?" do
          specify "blank" do
            subject.member_memberships_attributes = empty_params

            expect(subject.member_memberships).to have(0).items
          end

          specify "collective" do
            subject.member_memberships_attributes = invalid_params

            expect(subject.member_memberships).to have(0).items
          end
        end

        describe "after_save callbacks" do
          specify "#enforce_primariness" do
            subject.update!(member_memberships_attributes: valid_params)

            expect(subject.member_memberships).to have(1).items

            expect {
              subject.update!(individual: true)
            }.to change { Membership.count }.by(-1)

            expect(subject.reload.member_memberships).to have(0).items
          end
        end

        describe "allow_destroy" do
          it "destroys the identity but not the member" do
            subject.update!(member_memberships_attributes: valid_params)

            expect(subject.members).to eq([valid])

            subject.member_memberships.destroy_all

            subject.reload

            expect(subject.member_memberships).to eq([])
            expect(subject.members           ).to eq([])

            expect(valid.reload).to eq(valid)
          end
        end
      end

      context "group_memberships" do
        subject { create(:individual_creator) }

        let(  :valid) { create(:collective_creator) }
        let(:invalid) { create(:individual_creator) }

        let(  :valid_params) { { "0" => { group_id:   valid.id } } }
        let(:invalid_params) { { "0" => { group_id: invalid.id } } }
        let(  :empty_params) { { "0" => {                      } } }

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
          expect(subject.groups           ).to eq(Creator.none) # TODO

          subject.save!
          subject.reload

          expect(subject.group_memberships).to have(1).items
          expect(subject.groups           ).to eq([valid])
        end

        describe "rejects if #blank_or_individual?" do
          specify "blank" do
            subject.group_memberships_attributes = empty_params

            expect(subject.group_memberships).to have(0).items
          end

          specify "individual" do
            subject.group_memberships_attributes = invalid_params

            expect(subject.group_memberships).to have(0).items
          end
        end

        describe "after_save callbacks" do
          specify "#enforce_primariness" do
            subject.update!(group_memberships_attributes: valid_params)

            expect(subject.group_memberships).to have(1).items

            expect {
              subject.update!(individual: false)
            }.to change { Membership.count }.by(-1)

            expect(subject.reload.group_memberships).to have(0).items
          end
        end

        describe "allow_destroy" do
          it "destroys the identity but not the group" do
            subject.update!(group_memberships_attributes: valid_params)

            expect(subject.groups).to eq([valid])

            subject.group_memberships.destroy_all

            subject.reload

            expect(subject.group_memberships).to eq([])
            expect(subject.groups           ).to eq([])

            expect(valid.reload).to eq(valid)
          end
        end
      end

      context "booletania" do
        pending "self#individual_options"
        pending "self#individual_options"
        pending "#collective_text"
        pending "#individual_text"
      end
    end
  end

  context "validations" do
    describe "name" do
      it { should validate_presence_of(:name) }

      # it { should validate_inclusion_of(:primary).in_array([true, false]) }
      #
      # it { should validate_inclusion_of(:collective).in_array([true, false]) }
    end
  end

  context "hooks" do
    # Nothing so far
  end

  context "instance" do
    context "identities" do
      describe "#identities, #pseudonyms, #pseudonym_identities, #real_names, #real_name & #personae" do
        context "without identities" do
          let!(:kate_bush) { create(:kate_bush) }
          let!(      :gas) { create(:gas      ) }

          specify "primary" do
            expect(kate_bush.pseudonym_identities).to eq(Identity.none)
            expect(kate_bush.pseudonyms          ).to eq(Creator.none)
            expect(kate_bush.personae            ).to eq(Creator.none)

            expect(kate_bush.real_name_identities).to eq(Identity.none)
            expect(kate_bush.real_names          ).to eq(Creator.none)
            expect(kate_bush.real_name           ).to eq(nil)
          end

          specify "secondary" do
            expect(gas.pseudonym_identities      ).to eq(Identity.none)
            expect(gas.pseudonyms                ).to eq(Creator.none)
            expect(gas.personae                  ).to eq(Creator.none)

            expect(gas.real_name_identities      ).to eq(Identity.none)
            expect(gas.real_names                ).to eq(Creator.none)
            expect(gas.real_name                 ).to eq(nil)
          end
        end

        context "with identities" do
          let!(    :richie) { create(:richie_hawtin_with_pseudonyms) }
          let!(:plastikman) { described_class.find_by(name: "Plastikman") }
          let!(      :fuse) { described_class.find_by(name: "F.U.S.E."  ) }

          specify "primary" do
            expect(richie.pseudonym_identities    ).to have(2).items
            expect(richie.pseudonyms              ).to eq([fuse, plastikman])
            expect(richie.personae                ).to eq([fuse, plastikman])

            expect(richie.real_name_identities    ).to eq(Identity.none)
            expect(richie.real_names              ).to eq(Creator.none)
            expect(richie.real_name               ).to eq(nil)
          end

          specify "secondary" do
            expect(plastikman.pseudonym_identities).to eq(Identity.none)
            expect(plastikman.pseudonyms          ).to eq([])
            expect(plastikman.personae            ).to eq([fuse, richie])

            expect(plastikman.real_name_identities).to have(1).items
            expect(plastikman.real_names          ).to eq([richie])
            expect(plastikman.real_name           ).to eq(richie)

            expect(fuse.pseudonym_identities      ).to eq(Identity.none)
            expect(fuse.pseudonyms                ).to eq([])
            expect(fuse.personae                  ).to eq([plastikman, richie])

            expect(fuse.real_name_identities      ).to have(1).items
            expect(fuse.real_names                ).to eq([richie])
            expect(fuse.real_name                 ).to eq(richie)
          end
        end
      end
    end

    context "memberships" do
      describe "#member_memberships, #members, #group_memberships, #groups, #colleagues" do
        context "without members" do
          let!(:band) { create(:spawn         ) }
          let!(:solo) { create(:wolfgang_voigt) }

          specify "collective" do
            expect(band.member_memberships).to eq(Membership.none)
            expect(band.members           ).to eq(Creator.none)

            expect(band.group_memberships ).to eq(Membership.none)
            expect(band.groups            ).to eq(Creator.none)
            expect(band.colleagues        ).to eq(Creator.none)
          end

          specify "individual" do
            expect(solo.member_memberships).to eq(Membership.none)
            expect(solo.members           ).to eq(Creator.none)

            expect(solo.group_memberships ).to eq(Membership.none)
            expect(solo.groups            ).to eq(Creator.none)
            expect(solo.colleagues        ).to eq(Creator.none)
          end
        end

        context "with a single band" do
          let!(  :band) { create(:spawn_with_members) }
          let!(:richie) { described_class.find_by(name: "Richie Hawtin" ) }
          let!(  :fred) { described_class.find_by(name: "Fred Giannelli") }
          let!(   :dan) { described_class.find_by(name: "Dan Bell"      ) }

          specify "collective" do
            expect(band.member_memberships   ).to have(3).items
            expect(band.members              ).to eq([dan, fred, richie])

            expect(band.group_memberships    ).to eq(Membership.none)
            expect(band.groups               ).to eq(Creator.none)
            expect(band.colleagues           ).to eq(Creator.none)
          end

          specify "individual" do
            expect(richie.member_memberships ).to eq(Membership.none)
            expect(richie.members            ).to eq(Creator.none)

            expect(richie.group_memberships  ).to have(1).items
            expect(richie.groups             ).to eq([band])
            expect(richie.colleagues         ).to eq([dan, fred])

            expect(fred.member_memberships   ).to eq(Membership.none)
            expect(fred.members              ).to eq(Creator.none)

            expect(fred.group_memberships    ).to have(1).items
            expect(fred.groups               ).to eq([band])
            expect(fred.colleagues           ).to eq([dan, richie])

            expect(dan.member_memberships    ).to eq(Membership.none)
            expect(dan.members               ).to eq(Creator.none)

            expect(dan.group_memberships     ).to have(1).items
            expect(dan.groups                ).to eq([band])
            expect(dan.colleagues            ).to eq([fred, richie])
          end
        end

        context "with multiple bands" do
          let!(     :band) { create(:fleetwood_mac_with_members) }
          let!(   :stevie) { described_class.find_by(name: "Stevie Nicks"      ) }
          let!(  :lindsay) { described_class.find_by(name: "Lindsay Buckingham") }
          let!(:christine) { described_class.find_by(name: "Christine McVie"   ) }
          let!(     :mick) { described_class.find_by(name: "Mick Fleetwood"    ) }
          let!(     :john) { described_class.find_by(name: "John McVie"        ) }

          let!(:imaginary) { create(:musician, :primary, name: "Imaginary") }

          let!(:other_band) do
            other_band = create(:collective_creator, :primary, name: "Buckingham Nicks")

            create(:membership, group: other_band, member: lindsay  )
            create(:membership, group: other_band, member: stevie   )
            create(:membership, group: other_band, member: imaginary)

            other_band
          end

          specify "#members" do
            expect(      band.members).to eq([christine, john, lindsay, mick, stevie])
            expect(other_band.members).to eq([imaginary, lindsay, stevie            ])
          end

          specify "#groups" do
            expect(christine.groups).to eq([            band])
            expect(imaginary.groups).to eq([other_band      ])
            expect(     john.groups).to eq([            band])
            expect(  lindsay.groups).to eq([other_band, band])
            expect(     mick.groups).to eq([            band])
            expect(   stevie.groups).to eq([other_band, band])
          end

          specify "#colleagues" do
            expect(christine.colleagues).to eq([                      john, lindsay, mick, stevie])
            expect(imaginary.colleagues).to eq([                            lindsay,       stevie])
            expect(     john.colleagues).to eq([christine,                  lindsay, mick, stevie])
            expect(  lindsay.colleagues).to eq([christine, imaginary, john,          mick, stevie])
            expect(     mick.colleagues).to eq([christine,            john, lindsay,       stevie])
            expect(   stevie.colleagues).to eq([christine, imaginary, john, lindsay, mick        ])
          end
        end
      end
    end

    context "contributions" do
      pending "#media"

      pending "#roles"

      describe "#contributions_array" do
        pending "#contributions_by_role"
        pending "#contributions_by_medium"
        pending "#contributions_by_work"
      end
    end
  end
end
