# frozen_string_literal: true

require "rails_helper"

RSpec.describe Creator, type: :model do
  context "constants" do
    specify { expect(described_class).to have_constant(:MAX_NEW_IDENTITIES ) }
    specify { expect(described_class).to have_constant(:MAX_NEW_MEMBERSHIPS) }
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

      describe "self#available_pseudonyms" do
        let!(    :richie) { create(:richie_hawtin) }
        let!(  :robotman) { create(:robotman     ) }
        let!(:plastikman) { create(:plastikman   ) }
        let!(      :fuse) { create(:fuse         ) }
        let!(       :gas) { create(:gas          ) }
        let!( :identity ) { create(:minimal_identity, creator: richie, pseudonym: fuse) }

        specify "excludes used pseudonyms and alphabetizes" do
           expect(described_class.available_pseudonyms.to_a).to eq([
             gas,
             plastikman,
             robotman
           ])
        end
      end
    end

    context "memberships" do
      context "scopes" do
        pending "self#collective"
        pending "self#singular"
      end

      context "booleans" do
        pending "#collective?"
        pending "#singular?"
      end

      describe "self#available_members" do
        let!(      :band) { create(:fleetwood_mac     ) }
        let!(    :stevie) { create(:stevie_nicks      ) }
        let!(   :lindsay) { create(:lindsay_buckingham) }
        let!( :christine) { create(:christine_mcvie   ) }
        let!(      :mick) { create(:mick_fleetwood    ) }
        let!(      :john) { create(:john_mcvie        ) }
        let!(:membership) { create(:minimal_membership, creator: band, member: christine) }

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
    it { should have_many(:contributed_works).through(:contributions   ) }
    it { should have_many(:contributed_posts).through(:contributed_works) }

    it { should have_many(        :identities) }
    it { should have_many(:reverse_identities) }

    it { should have_many(:pseudonyms).through(        :identities).order("creators.name") }
    it { should have_many(:real_identities).through(:reverse_identities).order("creators.name") }

    it { should have_many(        :memberships) }
    it { should have_many(:reverse_memberships) }

    it { should have_many(:members).through(        :memberships).order("creators.name") }
    it { should have_many( :groups).through(:reverse_memberships).order("creators.name") }
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
        pending "self#collective_options"
        pending "self#singular_options"
        pending "#collective_text"
        pending "#singular_text"
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
    pending "#handle_identities"
    pending "#handle_memberships"
  end

  context "instance" do
    context "identities" do
      describe "#personae, #identities, #pseudonyms, #reverse_identities, #real_identities & #personae" do
        context "without identities" do
          let!(:kate_bush) { create(:kate_bush) }
          let!(      :gas) { create(:gas      ) }

          specify "primary" do
            expect(kate_bush.identities.length        ).to eq(0)
            expect(kate_bush.pseudonyms.length        ).to eq(0)
            expect(kate_bush.reverse_identities.length).to eq(0)
            expect(kate_bush.real_identities.length   ).to eq(0)
            expect(kate_bush.personae.length          ).to eq(0)
            expect(kate_bush.personae                 ).to eq(Creator.none)
          end

          specify "secondary" do
            expect(gas.identities.length        ).to eq(0)
            expect(gas.pseudonyms.length        ).to eq(0)
            expect(gas.reverse_identities.length).to eq(0)
            expect(gas.real_identities.length   ).to eq(0)
            expect(gas.personae.length          ).to eq(0)
            expect(gas.personae                 ).to eq(Creator.none)
          end
        end

        context "with identities" do
          let!(    :richie) { create(:richie_hawtin_with_pseudonyms) }
          let!(:plastikman) { described_class.find_by(name: "Plastikman") }
          let!(      :fuse) { described_class.find_by(name: "F.U.S.E."  ) }

          specify "primary" do
            expect(richie.identities.length            ).to eq(2)
            expect(richie.pseudonyms.length            ).to eq(2)
            expect(richie.reverse_identities.length    ).to eq(0)
            expect(richie.real_identities.length       ).to eq(0)
            expect(richie.personae.length              ).to eq(2)
            expect(richie.personae.to_a                ).to eq([fuse, plastikman])
          end

          specify "secondary" do
            expect(plastikman.identities.length        ).to eq(0)
            expect(plastikman.pseudonyms.length        ).to eq(0)
            expect(plastikman.reverse_identities.length).to eq(1)
            expect(plastikman.real_identities.length   ).to eq(1)
            expect(plastikman.personae.length          ).to eq(2)
            expect(plastikman.personae.to_a            ).to eq([fuse, richie])

            expect(fuse.identities.length              ).to eq(0)
            expect(fuse.pseudonyms.length              ).to eq(0)
            expect(fuse.reverse_identities.length      ).to eq(1)
            expect(fuse.real_identities.length         ).to eq(1)
            expect(fuse.personae.length                ).to eq(2)
            expect(fuse.personae.to_a                  ).to eq([plastikman, richie])
          end
        end
      end
    end

    context "memberships" do
      context "without members" do
        let!(:band) { create(:spawn) }

        specify "#members" do
          expect(band.members).to eq([])
        end
      end

      context "with a single band" do
        let!(  :band) { create(:spawn_with_members) }
        let!(:richie) { described_class.find_by(name: "Richie Hawtin" ) }
        let!(  :fred) { described_class.find_by(name: "Fred Giannelli") }
        let!(   :dan) { described_class.find_by(name: "Dan Bell"      ) }

        specify "#members" do
          expect(band.members).to eq([dan, fred, richie])
        end

        specify "#groups" do
          expect(richie.groups).to eq([band])
          expect(  fred.groups).to eq([band])
          expect(   dan.groups).to eq([band])
        end

        specify "#colleagues" do
          expect(richie.colleagues.to_a).to eq([dan, fred   ])
          expect(  fred.colleagues.to_a).to eq([dan, richie ])
          expect(   dan.colleagues.to_a).to eq([fred, richie])
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

          create(:membership, creator: other_band, member: lindsay  )
          create(:membership, creator: other_band, member: stevie   )
          create(:membership, creator: other_band, member: imaginary)

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
