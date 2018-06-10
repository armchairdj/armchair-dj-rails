require "rails_helper"

RSpec.describe Aspect, type: :model do
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
      let(       :mood) { create(:minimal_category, name: "Mood" ) }
      let(      :genre) { create(:minimal_category, name: "Genre") }

      let(      :draft) { create(:minimal_aspect,                       category_id: genre.id, name: "Trip-Hop" ) }
      let(:published_1) { create(:minimal_aspect, :with_published_post, category_id: mood.id,  name: "Paranoid" ) }
      let(:published_2) { create(:minimal_aspect, :with_published_post, category_id: genre.id, name: "Downtempo") }

      let(        :ids) { [draft, published_1, published_2].map(&:id) }
      let( :collection) { described_class.where(id: ids) }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:category, :works, :reviews, :mixtapes, :creators, :contributors) }
        it { is_expected.to contain_exactly(draft, published_1, published_2) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        it { is_expected.to eager_load(:category, :works, :reviews, :mixtapes, :creators, :contributors) }
        it { is_expected.to contain_exactly(draft, published_1, published_2) }
      end

      describe "self#for_site" do
        subject { collection.for_site }

        it { is_expected.to eager_load(:category, :works, :reviews, :mixtapes, :creators, :contributors) }
        it { is_expected.to eq([published_2, published_1]) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:category) }

    it { is_expected.to have_and_belong_to_many(:works) }

    it { is_expected.to have_many(:creators    ).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }
    it { is_expected.to have_many(:reviews     ).through(:works) }
    it { is_expected.to have_many(:mixtapes    ).through(:works) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:category) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:category_id) }
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      it { is_expected.to eq([instance.category.name, instance.name]) }
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.category.name, instance.name]) }
    end

    describe "#display_name" do
      subject { create_minimal_instance(name_for_category: "Foo", name: "Bar") }

      specify { expect(subject.display_name                ).to eq("Foo: Bar") }
      specify { expect(subject.display_name(connector: "/")).to eq("Foo/Bar" ) }
    end
  end
end
