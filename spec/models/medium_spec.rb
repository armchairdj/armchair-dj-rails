require "rails_helper"

RSpec.describe Medium, type: :model do
  context "constants" do
    it { should have_constant(:MAX_ROLES_AT_ONCE ) }
    it { should have_constant(:MAX_FACETS_AT_ONCE ) }
  end

  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_summarizable_model"

    it_behaves_like "a_viewable_model"
  end

  context "class" do
    describe "self#admin_scopes" do
      specify "keys are short tab names" do
        expect(described_class.admin_scopes.keys).to eq([
          "All",
          "Viewable",
          "Non-Viewable",
        ])
      end
    end

    describe "self#default_admin_scope" do
      specify { expect(described_class.default_admin_scope).to eq(:for_admin) }
    end
  end

  context "scope-related" do
    context "basics" do
      let!( :song_medium) { create(:minimal_medium, name: "Song" ) }
      let!(:album_medium) { create(:minimal_medium, name: "Album") }
      let!(:movie_medium) { create(:minimal_medium, name: "Movie") }

      let(:ids) { [song_medium, album_medium, movie_medium].map(&:id) }

      before(:each) do
        create(:review, :with_author, :with_body, :published,
          "work_attributes" => attributes_for(:minimal_work, medium: song_medium)
        )

        create(:review, :with_author, :with_body, :published,
          "work_attributes" => attributes_for(:minimal_work, medium: album_medium)
        )

        create(:review, :with_author, :with_body, :draft,
          "work_attributes" => attributes_for(:minimal_work, medium: movie_medium)
        )
      end

      describe "self#eager" do
        subject { described_class.eager }

        it { should eager_load(:roles, :works) }
      end

      describe "self#for_admin" do
        subject { described_class.for_admin.where(id: ids) }

        specify "includes all media, unsorted" do
          should match_array([song_medium, album_medium, movie_medium])
        end

        it { should eager_load(:roles, :works) }
      end

      describe "self#for_site" do
        subject { described_class.for_site.where(id: ids) }

        specify "includes only media with published posts, sorted alphabetically" do
          should eq([album_medium, song_medium])
        end

        it { should eager_load(:roles, :works) }
      end
    end
  end

  context "associations" do
    it { should have_many(:roles) }

    it { should have_many(:works) }

    it { should have_many(:creators).through(:works) }

    it { should have_many(:posts).through(:works) }

    it { should have_many(:facets) }

    it { should have_many(:categories).through(:facets) }

    it { should have_many(:tags).through(:categories) }
  end

  context "attributes" do
    context "nested" do
      context "for roles" do
        it { should accept_nested_attributes_for(:roles) }

        pending "accepts"

        pending "rejects"

        pending "allow_destroy"

        describe "#prepare_roles" do
          context "new instance" do
            subject { described_class.new }

            it "builds 10 roles" do
              expect(subject.roles).to have(0).items

              subject.prepare_roles

              expect(subject.roles).to have(10).items
            end
          end

          context "saved instance with saved roles" do
            subject { create(:minimal_medium, :with_role) }

            it "builds 10 more roles" do
              expect(subject.roles).to have(1).items

              subject.prepare_roles

              expect(subject.roles).to have(11).items
            end
          end
        end
      end

      context "for facets" do
        it { should accept_nested_attributes_for(:facets) }

        pending "accepts"

        pending "rejects"

        pending "allow_destroy"

        describe "#prepare_facets" do
          context "new instance" do
            subject { described_class.new }

            it "builds 10 facets" do
              expect(subject.facets).to have(0).items

              subject.prepare_facets

              expect(subject.facets).to have(10).items
            end
          end

          context "saved instance with saved facets" do
            subject { create(:minimal_medium, :with_existing_category) }

            it "builds 10 more facets" do
              expect(subject.facets).to have(1).items

              subject.prepare_facets

              expect(subject.facets).to have(11).items
            end
          end
        end
      end
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:name) }

    context "custom" do
      describe "#at_least_one_role" do
        subject { build(:minimal_medium) }

        before(:each) do
           allow(subject).to receive(:at_least_one_role).and_call_original
          expect(subject).to receive(:at_least_one_role)
        end

        specify "valid" do
          expect(subject).to be_valid
        end

        specify "invalid" do
          subject.roles = []

          expect(subject).to_not be_valid

          expect(subject).to have_error(roles: :missing)
        end
      end
    end
  end

  context "instance" do
    describe "#tags_by_category" do
      subject { medium.tags_by_category }

      let(:medium) do
        create(:minimal_medium, :with_tags, facets_attributes: {
          "0" => attributes_for(:facet, category_id: create(:category, name: "Genre").id),
          "1" => attributes_for(:facet, category_id: create(:category, name: "Mood" ).id)
        })
      end

      pending "provides a hash of options for category-specific tag dropdowns"
    end

    pending "#alpha_parts"
  end
end
