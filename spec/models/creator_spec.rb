# frozen_string_literal: true

require "rails_helper"

RSpec.describe Creator, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_displayable_model"

    it_behaves_like "a_linkable_model"

    it_behaves_like "a_sluggable_model"

    it_behaves_like "a_summarizable_model"

    it_behaves_like "a_viewable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let!( :richie) { create(:creator, name: "Richie Hawtin") }
      let!(    :amy) { create(:creator, name: "Amy Winehouse") }
      let!(   :kate) { create(:creator, name: "Kate Bush"    ) }
      let!(   :carl) { create(:creator, name: "Carl Craig"   ) }
      let!(  :feist) { create(:creator, name: "Feist"        ) }
      let!(:derrick) { create(:creator, name: "Derrick May"  ) }

      let(:ids) { [richie, amy, kate, carl, feist, derrick].map(&:id) }

      before(:each) do
        create(:minimal_review, :with_author, :with_body, :published,
          "work_attributes" => attributes_for(:work, :with_existing_medium, :with_title).merge({
            "credits_attributes" => { "0" => { "creator_id" => richie.id } }
          })
        )

        create(:minimal_review, :with_author, :with_body, :published,
          "work_attributes" => attributes_for(:work, :with_existing_medium, :with_title).merge({
            "credits_attributes" => { "0" => { "creator_id" => carl.id } }
          })
        )

        create(:minimal_review, :with_author, :with_body, :draft,
          "work_attributes" => attributes_for(:work, :with_existing_medium, :with_title).merge({
            "credits_attributes" => { "0" => { "creator_id" => derrick.id } }
          })
        )
      end

      describe "self#eager" do
        subject { described_class.eager }

        specify do
          is_expected.to eager_load(
            :pseudonyms, :real_names, :members, :groups, :credits, :works,
            :reviews, :contributions, :contributed_works, :contributed_reviews
          )
        end
      end

      describe "self#for_admin" do
        subject { described_class.for_admin.where(id: ids) }

        specify "includes all creators, unsorted" do
          is_expected.to match_array([richie, amy, kate, carl, feist, derrick])
        end

        specify do
          is_expected.to eager_load(
            :pseudonyms, :real_names, :members, :groups, :credits, :works,
            :reviews, :contributions, :contributed_works, :contributed_reviews
          )
        end
      end

      describe "self#for_site" do
        subject { described_class.for_site.where(id: ids) }

        specify "includes only creators with published reviews, sorted alphabetically" do
          is_expected.to eq([carl, richie])
        end

        specify do
          is_expected.to eager_load(
            :pseudonyms, :real_names, :members, :groups, :credits, :works,
            :reviews, :contributions, :contributed_works, :contributed_reviews
          )
        end
      end
    end

    context "identities" do
      context "scopes and booleans" do
        let!(  :primary) { create(  :primary_creator) }
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

    context "memberships" do
      context "scopes and booleans" do
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

      context "collections" do
        describe "self#available_members" do
          subject { described_class.available_members }

          let!(      :band) { create(:fleetwood_mac     ) }
          let!(    :stevie) { create(:stevie_nicks      ) }
          let!(   :lindsay) { create(:lindsay_buckingham) }
          let!( :christine) { create(:christine_mcvie   ) }
          let!(      :mick) { create(:mick_fleetwood    ) }
          let!(      :john) { create(:john_mcvie        ) }
          let!(:membership) { create(:minimal_membership, group: band, member: christine) }

          it "includes even used members and alphabetizes" do
            is_expected.to contain_exactly(christine, john, lindsay, mick, stevie)
          end
        end
      end
    end
  end

  context "associations" do
    it { is_expected.to have_many(:credits) }
    it { is_expected.to have_many(:works  ).through(:credits) }
    it { is_expected.to have_many(:reviews).through(:works  ) }

    it { is_expected.to have_many(:contributions) }
    it { is_expected.to have_many(:contributed_works  ).through(:contributions    ) }
    it { is_expected.to have_many(:contributed_reviews).through(:contributed_works) }

    it { is_expected.to have_many(:pseudonym_identities) }
    it { is_expected.to have_many(:real_name_identities) }

    it { is_expected.to have_many(:pseudonyms).through(:pseudonym_identities).order("creators.name") }
    it { is_expected.to have_many(:real_names).through(:real_name_identities).order("creators.name") }

    it { is_expected.to have_many(:member_memberships) }
    it { is_expected.to have_many( :group_memberships) }

    it { is_expected.to have_many(:members).through(:member_memberships).order("creators.name") }
    it { is_expected.to have_many( :groups).through( :group_memberships).order("creators.name") }
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
      end

      context "booletania" do
        context "class" do
          specify "self#individual_options" do
            expect(described_class.individual_options).to eq([
              ["This is an individual creator. It can belong to a group.", true],
              ["This is a group creator. It can have members.",           false]
            ])
          end

          specify "self#collective_options" do
            expect(described_class.primary_options).to eq([
              ["This is a primary creator. It can have pseudonyms.",   true],
              ["This is a secondary creator. It can be a pseudonym.", false]
            ])
          end
        end

        context "instance" do
          subject { create_minimal_instance }

          describe "#individual_text" do
            specify "individual" do
              subject.individual = true

              expect(subject.individual_text).to eq(
                "This is an individual creator. It can belong to a group."
              )
            end

            specify "collective" do
              subject.individual = false

              expect(subject.individual_text).to eq(
                "This is a group creator. It can have members."
              )
            end
          end

          describe "#primary_text" do
            specify "primary" do
              subject.primary = true

              expect(subject.primary_text).to eq(
                "This is a primary creator. It can have pseudonyms."
              )
            end

            specify "secondary" do
              subject.primary = false

              expect(subject.primary_text).to eq(
                "This is a secondary creator. It can be a pseudonym."
              )
            end
          end
        end
      end
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    describe "name" do
      it { is_expected.to validate_presence_of(:name) }

      # it { is_expected.to validate_inclusion_of(:primary).in_array([true, false]) }
      #
      # it { is_expected.to validate_inclusion_of(:collective).in_array([true, false]) }
    end
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

          let!(:imaginary) { create(:minimal_creator, :primary, name: "Imaginary") }

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

    describe "#display_roles" do
      subject { create_minimal_instance }

      let(:tv_show) { create(:minimal_medium, name: "TV Show") }
      let(   :book) { create(:minimal_medium, name: "Book"   ) }

      let(    :editor) { create(:minimal_role, medium: book,    name: "Editor"    ) }
      let(    :author) { create(:minimal_role, medium: book,    name: "Author"    ) }
      let(:showrunner) { create(:minimal_role, medium: tv_show, name: "Showrunner") }
      let(  :director) { create(:minimal_role, medium: tv_show, name: "Director"  ) }

      let(:tv_show_work) { create(:minimal_work, medium: tv_show) }
      let(   :book_work) { create(:minimal_work, medium: book   ) }

      let!( :credit_1) { subject.credits.create(      work: tv_show_work                  ) }
      let!(:contrib_1) { subject.contributions.create(work: tv_show_work, role: showrunner) }
      let!(:contrib_2) { subject.contributions.create(work: tv_show_work, role: director  ) }

      let!( :credit_2) { subject.credits.create(      work: book_work              ) }
      let!(:contrib_3) { subject.contributions.create(work: book_work, role: editor) }
      let!(:contrib_4) { subject.contributions.create(work: book_work, role: author) }

      let!(:review) { create(:minimal_review, :with_body, :published, work_id: book_work.id) }

      it "returns hash of credits and contributions sorted alphabetically and grouped by medium" do
        expect(subject.display_roles).to eq({
          "Book"    => ["Author",  "Creator",  "Editor"    ],
          "TV Show" => ["Creator", "Director", "Showrunner"]
        })
      end

      it "takes a for_site option that excludes unviewable roles" do
        expect(subject.display_roles(for_site: true)).to eq({
          "Book"    => ["Author", "Creator", "Editor"]
        })
      end
    end

    describe "#sluggable_parts" do
      let(:instance) { create_minimal_instance }

      subject { instance.sluggable_parts }

      it { is_expected.to eq([instance.name]) }
    end

    describe "#alpha_parts" do
      let(:instance) { create_minimal_instance }

      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.name]) }
    end
  end
end
