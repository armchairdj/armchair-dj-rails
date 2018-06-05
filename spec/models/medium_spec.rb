require "rails_helper"

RSpec.describe Medium, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_displayable_model"
  end

  context "class" do
    # Nothing so far.
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

        it { is_expected.to eager_load(:roles, :works) }
      end

      describe "self#for_admin" do
        subject { described_class.for_admin.where(id: ids) }

        specify "includes all media, unsorted" do
          is_expected.to match_array([song_medium, album_medium, movie_medium])
        end

        it { is_expected.to eager_load(:roles, :works) }
      end

      describe "self#for_site" do
        subject { described_class.for_site.where(id: ids) }

        specify "includes only media with published posts, sorted alphabetically" do
          is_expected.to eq([album_medium, song_medium])
        end

        it { is_expected.to eager_load(:roles, :works) }
      end
    end
  end

  context "associations" do
    it { is_expected.to have_many(:roles) }

    it { is_expected.to have_many(:works) }

    it { is_expected.to have_many(:creators).through(:works) }

    it { is_expected.to have_many(:posts).through(:works) }

    it { is_expected.to have_many(:facets) }

    it { is_expected.to have_many(:categories).through(:facets) }

    it { is_expected.to have_many(:tags).through(:categories) }
  end

  context "attributes" do
    context "nested" do
      subject { create_minimal_instance }

      context "for roles" do
        it { is_expected.to accept_nested_attributes_for(:roles).allow_destroy(true) }

        pending "accepts"

        pending "rejects"

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
        it { is_expected.to accept_nested_attributes_for(:facets).allow_destroy(true) }

        pending "accepts"

        pending "rejects"

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

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_uniqueness_of(:name) }

    context "custom" do
      describe "#at_least_one_role" do
        subject { build(:minimal_medium) }

        before(:each) do
           allow(subject).to receive(:at_least_one_role).and_call_original
          is_expected.to receive(:at_least_one_role)
        end

        specify "valid" do
          is_expected.to be_valid
        end

        specify "invalid" do
          subject.roles = []

          is_expected.to_not be_valid

          is_expected.to have_error(roles: :missing)
        end
      end
    end
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    pending "#reorder_facets!"

    describe "#tags_by_category" do
      let(:instance) do
        create(:minimal_medium, :with_tags, facets_attributes: {
          "0" => attributes_for(:facet, category_id: create(:category, name: "Genre").id),
          "1" => attributes_for(:facet, category_id: create(:category, name: "Mood" ).id)
        })
      end

      subject { instance.tags_by_category }

      pending "provides a hash of options for category-specific tag dropdowns"
    end

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      it { is_expected.to eq([instance.name]) }
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.name]) }
    end
  end
end
