# frozen_string_literal: true

require "rails_helper"

RSpec.describe Creator, type: :model do
  context "constants" do
    # Nothing so far.
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

  context "scopes" do
    describe "alphabetical" do
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

    pending "eager"

    pending "for_admin"

    pending "for_site"

    context "identities" do
      pending "primary"
      pending "secondary"

      context "booleans" do
        pending "#primary?"
        pending "#secondary?"
      end
    end

    context "memberships" do
      pending "collective"
      pending "singular"

      context "booleans" do
        pending "#collective?"
        pending "#singular?"
      end
    end
  end

  context "associations" do
    describe "associations" do
      it { should have_many(:contributions) }

      it { should have_many(:works            ).through(:contributions) }
      it { should have_many(:contributed_works).through(:contributions) }

      it { should have_many(:posts).through(:works).with_foreign_key("author_id") }

      it { should have_many(:identities) }
      it { should have_many(:pseudonyms).through(:identities).order("creators.name") }

      it { should have_many(:memberships) }
      it { should have_many(:members).through(:memberships).order("creators.name") }
    end
  end

  context "attributes" do
    context "nested" do
      context "identities" do
        pending "accepts"
        pending "rejects"
      end

      context "memberships" do
        pending "accepts"
        pending "rejects"
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
    # Nothing so far.
  end

  context "instance" do
    context "identities" do
      describe "#personae" do
        context "without identities" do
          let!(:kate_bush) { create(:kate_bush) }
          let!(      :gas) { create(:gas      ) }

          context "without personae" do
            specify "primary" do
              expect(kate_bush.personae).to eq([])
            end

            specify "secondary" do
              expect(gas.personae).to eq([])
            end
          end
        end

        context "with identities" do
          let!(    :richie) { create(:richie_hawtin_with_pseudonyms) }
          let!(:plastikman) { described_class.find_by(name: "Plastikman") }
          let!(      :fuse) { described_class.find_by(name: "F.U.S.E."  ) }

          specify "primary" do
            expect(richie.personae).to eq([fuse, plastikman])
          end

          specify "secondary" do
            expect(plastikman.personae).to eq([fuse, richie])
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
          expect(richie.colleagues).to eq([dan, fred   ])
          expect(  fred.colleagues).to eq([dan, richie ])
          expect(   dan.colleagues).to eq([fred, richie])
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
          expect(christine.colleagues).to eq([                      john, lindsay, mick, stevie])
          expect(imaginary.colleagues).to eq([                            lindsay,       stevie])
          expect(     john.colleagues).to eq([christine,                  lindsay, mick, stevie])
          expect(  lindsay.colleagues).to eq([christine, imaginary, john,          mick, stevie])
          expect(     mick.colleagues).to eq([christine,            john, lindsay,       stevie])
          expect(   stevie.colleagues).to eq([christine, imaginary, john, lindsay, mick        ])
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
