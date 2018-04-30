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
    context "identities" do
      context "scopes" do
        pending "self#primary"
        pending "self#secondary"
      end

      context "booleans" do
        pending "#primary?"
        pending "#secondary?"
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
             expect(described_class.available_pseudonyms.to_a).to eq([
               gas,
               plastikman,
               robotman
             ])
          end
        end

        describe "#available_pseudonyms" do
          specify "includes own pseudonyms" do
             expect(richie.available_pseudonyms.to_a).to eq([
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
      context "scopes" do
        pending "self#individual"
        pending "self#collective"
      end

      context "booleans" do
        pending "#individual?"
        pending "#collective?"
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
             expect(described_class.available_members.to_a).to eq([
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

    pending "eager"

    pending "for_admin"

    pending "for_site"

    describe "self#alphabetical" do
      let!(:zorro  ) { create(:creator, name: "Zorro the Gay Blade") }
      let!(:amy_1  ) { create(:creator, name: "amy winehouse") }
      let!(:kate   ) { create(:creator, name: "Kate Bush") }
      let!(:amy_2  ) { create(:creator, name: "Amy Wino") }
      let!(:anthony) { create(:creator, name: "Anthony Childs") }
      let!(:zero   ) { create(:creator, name: "0773") }

      specify { expect(described_class.alphabetical.to_a).to eq([
        zero,
        amy_1,
        amy_2,
        anthony,
        kate,
        zorro
      ]) }
    end
  end

  context "associations" do
    it { should have_many(:credits) }
    it { should have_many(:works).through(:credits) }
    it { should have_many(:posts).through(:works  ) }

    it { should have_many(:contributions) }
    it { should have_many(:contributed_works).through(:contributions    ) }
    it { should have_many(:contributed_posts).through(:contributed_works) }

    it { should have_many(        :identities) }
    it { should have_many(:inverse_identities) }

    it { should have_many(:pseudonyms).through(        :identities).order("creators.name") }
    it { should have_many(:real_names).through(:inverse_identities).order("creators.name") }

    it { should have_many(        :memberships) }
    it { should have_many(:inverse_memberships) }

    it { should have_many(:members).through(        :memberships).order("creators.name") }
    it { should have_many( :groups).through(:inverse_memberships).order("creators.name") }
  end

  context "attributes" do
    context "nested" do
      context "identities" do
        pending "accepts"
        pending "rejects"
        pending "#prepare_identities"
      end

      context "memberships" do
        pending "accepts"
        pending "rejects"
        pending "#prepare_memberships"
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
    pending "#enforce_primariness"
    pending "#enforce_individuality"
  end

  context "instance" do
    context "identities" do
      describe "#identities, #pseudonyms, #inverse_identities, #real_names, #real_name & #personae" do
        context "without identities" do
          let!(:kate_bush) { create(:kate_bush) }
          let!(      :gas) { create(:gas      ) }

          specify "primary" do
            expect(kate_bush.identities        ).to eq(Identity.none)
            expect(kate_bush.pseudonyms        ).to eq(Creator.none)
            expect(kate_bush.personae          ).to eq(Creator.none)

            expect(kate_bush.inverse_identities).to eq(Identity.none)
            expect(kate_bush.real_names        ).to eq(Creator.none)
            expect(kate_bush.real_name         ).to eq(nil)
          end

          specify "secondary" do
            expect(gas.identities              ).to eq(Identity.none)
            expect(gas.pseudonyms              ).to eq(Creator.none)
            expect(gas.personae                ).to eq(Creator.none)

            expect(gas.inverse_identities      ).to eq(Identity.none)
            expect(gas.real_names              ).to eq(Creator.none)
            expect(gas.real_name               ).to eq(nil)
          end
        end

        context "with identities" do
          let!(    :richie) { create(:richie_hawtin_with_pseudonyms) }
          let!(:plastikman) { described_class.find_by(name: "Plastikman") }
          let!(      :fuse) { described_class.find_by(name: "F.U.S.E."  ) }

          specify "primary" do
            expect(richie.identities            ).to have(2).items
            expect(richie.pseudonyms.to_a       ).to eq([fuse, plastikman])
            expect(richie.personae.to_a         ).to eq([fuse, plastikman])

            expect(richie.inverse_identities    ).to eq(Identity.none)
            expect(richie.real_names            ).to eq(Creator.none)
            expect(richie.real_name             ).to eq(nil)
          end

          specify "secondary" do
            expect(plastikman.identities        ).to eq(Identity.none)
            expect(plastikman.pseudonyms.to_a   ).to eq([])
            expect(plastikman.personae.to_a     ).to eq([fuse, richie])

            expect(plastikman.inverse_identities).to have(1).items
            expect(plastikman.real_names.to_a   ).to eq([richie])
            expect(plastikman.real_name         ).to eq(richie)

            expect(fuse.identities              ).to eq(Identity.none)
            expect(fuse.pseudonyms.to_a         ).to eq([])
            expect(fuse.personae.to_a           ).to eq([plastikman, richie])

            expect(fuse.inverse_identities      ).to have(1).items
            expect(fuse.real_names.to_a         ).to eq([richie])
            expect(fuse.real_name               ).to eq(richie)
          end
        end
      end
    end

    context "memberships" do
      describe "#memberships, #members, #inverse_memberships, #groups, #colleagues" do
        context "without members" do
          let!(:band) { create(:spawn         ) }
          let!(:solo) { create(:wolfgang_voigt) }

          specify "collective" do
            expect(band.memberships        ).to eq(Membership.none)
            expect(band.members            ).to eq(Creator.none)

            expect(band.inverse_memberships).to eq(Membership.none)
            expect(band.groups             ).to eq(Creator.none)
            expect(band.colleagues         ).to eq(Creator.none)
          end

          specify "individual" do
            expect(solo.memberships        ).to eq(Membership.none)
            expect(solo.members            ).to eq(Creator.none)

            expect(solo.inverse_memberships).to eq(Membership.none)
            expect(solo.groups             ).to eq(Creator.none)
            expect(solo.colleagues         ).to eq(Creator.none)
          end
        end

        context "with a single band" do
          let!(  :band) { create(:spawn_with_members) }
          let!(:richie) { described_class.find_by(name: "Richie Hawtin" ) }
          let!(  :fred) { described_class.find_by(name: "Fred Giannelli") }
          let!(   :dan) { described_class.find_by(name: "Dan Bell"      ) }

          describe "collective" do
            specify { expect(band.memberships        ).to have(3).items }
            specify { expect(band.members.to_a       ).to eq([dan, fred, richie]) }

            specify { expect(band.inverse_memberships).to eq(Membership.none) }
            specify { expect(band.groups             ).to eq(Creator.none) }
            specify { expect(band.colleagues         ).to eq(Creator.none) }
          end

          specify "individual" do
            expect(richie.memberships        ).to eq(Membership.none)
            expect(richie.members            ).to eq(Creator.none)
            expect(richie.inverse_memberships).to have(1).items
            expect(richie.groups             ).to eq([band])
            expect(richie.colleagues.to_a    ).to eq([dan, fred])

            expect(fred.memberships          ).to eq(Membership.none)
            expect(fred.members              ).to eq(Creator.none)
            expect(fred.inverse_memberships  ).to have(1).items
            expect(fred.groups               ).to eq([band])
            expect(fred.colleagues.to_a      ).to eq([dan, richie])

            expect(dan.memberships           ).to eq(Membership.none)
            expect(dan.members               ).to eq(Creator.none)
            expect(dan.inverse_memberships   ).to have(1).items
            expect(dan.groups                ).to eq([band])
            expect(dan.colleagues.to_a       ).to eq([fred, richie])
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
            expect(christine.colleagues.to_a).to eq([                      john, lindsay, mick, stevie])
            expect(imaginary.colleagues.to_a).to eq([                            lindsay,       stevie])
            expect(     john.colleagues.to_a).to eq([christine,                  lindsay, mick, stevie])
            expect(  lindsay.colleagues.to_a).to eq([christine, imaginary, john,          mick, stevie])
            expect(     mick.colleagues.to_a).to eq([christine,            john, lindsay,       stevie])
            expect(   stevie.colleagues.to_a).to eq([christine, imaginary, john, lindsay, mick        ])
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
