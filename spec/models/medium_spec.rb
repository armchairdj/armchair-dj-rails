require "rails_helper"

RSpec.describe Medium, type: :model do
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
      let!( :song_medium) { create(:minimal_medium, :with_published_post, name: "Song" ) }
      let!(:album_medium) { create(:minimal_medium, :with_published_post, name: "Album") }
      let!(:movie_medium) { create(:minimal_medium,                       name: "Movie") }
      let(          :ids) { [song_medium, album_medium, movie_medium].map(&:id) }
      let(   :collection) { described_class.where(id: ids) }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:roles, :works, :reviews, :facets, :categories, :aspects) }
        it { is_expected.to match_array(collection.to_a) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin.where(id: ids) }

        it { is_expected.to match_array(collection.to_a) }
        it { is_expected.to eager_load(:roles, :works, :reviews, :facets, :categories, :aspects) }
      end

      describe "self#for_site" do
        subject { collection.for_site.where(id: ids) }

        it { is_expected.to eq([album_medium, song_medium]) }
        it { is_expected.to eager_load(:roles, :works, :reviews, :facets, :categories, :aspects) }
      end
    end
  end

  context "associations" do
    it { is_expected.to have_many(:roles) }

    it { is_expected.to have_many(:works) }

    it { is_expected.to have_many(:creators).through(:works) }

    it { is_expected.to have_many(:reviews).through(:works) }

    describe "facets" do
      let(:instance) { create_complete_instance }

      it { is_expected.to have_many(:facets) }

      describe "ordering" do
        subject { instance.facets.map(&:position) }

        it { is_expected.to eq((0..2).to_a) }
      end
    end

    it { is_expected.to have_many(:categories).through(:facets) }

    it { is_expected.to have_many(:aspects).through(:categories) }
  end

  context "attributes" do
    context "nested" do
      subject { create_minimal_instance }

      context "for roles" do
        it { is_expected.to accept_nested_attributes_for(:roles).allow_destroy(true) }

        describe "rejects" do
          let(:instance) do
            create(:minimal_medium, roles_attributes: {
              "0" => attributes_for(:minimal_role, name: "first"),
              "1" => attributes_for(:minimal_role, name: "second"),
              "2" => attributes_for(:minimal_role, name: ""),
            })
          end

          it "rejects blank name" do
            instance.save!

            expect(instance.roles.length).to eq(2)
          end
        end

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

        describe "rejects" do
          let(:instance) do
            create(:minimal_medium, facets_attributes: {
              "0" => attributes_for(:minimal_facet, category_id: create(:minimal_category).id),
              "1" => attributes_for(:minimal_facet, category_id: create(:minimal_category).id),
              "2" => attributes_for(:minimal_facet, category_id: nil),
            })
          end

          it "rejects blank category_id" do
            instance.save!

            expect(instance.facets.length).to eq(2)
          end
        end

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
            subject { create(:minimal_medium, :with_facet) }

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

    describe "#reorder_facets!" do
      let( :instance) { create_complete_instance }
      let(      :ids) { instance.facets.map(&:id) }
      let( :shuffled) { ids.shuffle }
      let(    :other) { create_complete_instance }
      let(:other_ids) { other.facets.map(&:id) }

      it "reorders" do
        instance.reorder_facets!(shuffled)

        actual = instance.reload.facets

        expect(actual.map(&:id)).to eq(shuffled)
        expect(actual.map(&:position)).to eq((0..2).to_a)
      end

      it "raises if bad ids" do
        expect {
          instance.reorder_facets!(other_ids)
        }.to raise_exception(ArgumentError)
      end

      it "raises if not enough ids" do
        shuffled.shift

        expect {
          instance.reorder_facets!(shuffled)
        }.to raise_exception(ArgumentError)
      end
    end

    describe "#category_aspect_options" do
      let( :mood) { create(:category, :with_aspects, name: "Mood" ) }
      let(:genre) { create(:category, :with_aspects, name: "Genre") }

      let(:instance) do
        instance = create(:minimal_medium)

        instance.facets.create(category_id: genre.id)
        instance.facets.create(category_id:  mood.id)

        instance.reload
      end

      subject { instance.category_aspect_options }

      it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }

      it { is_expected.to eager_load(:aspects) }

      it { is_expected.to eq([genre, mood]) }
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
