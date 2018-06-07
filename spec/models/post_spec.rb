# frozen_string_literal: true

require "rails_helper"

RSpec.describe Post, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_linkable_model"

    it_behaves_like "a_publishable_model"

    it_behaves_like "a_sluggable_model"

    it_behaves_like "a_summarizable_model"
  end

  context "scope-related" do
    context "basics" do
      let!(     :draft) { create_minimal_instance(:draft    ) }
      let!( :scheduled) { create_minimal_instance(:scheduled) }
      let!( :published) { create_minimal_instance(:published) }
      let!(       :ids) { [draft, scheduled, published].map(&:id) }
      let!(:collection) { described_class.where(id: ids) }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:author) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        specify do
          is_expected.to contain_exactly(draft, scheduled, published)
        end

        it { is_expected.to eager_load(:author) }
      end

      describe "self#for_site" do
        subject { collection.for_site }

        it { is_expected.to eq [published] }

        it { is_expected.to eager_load(:author) }
      end
    end
  end

  context "associations" do
    it { is_expected.to have_and_belong_to_many(:tags) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:title) }
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#type" do
      specify { expect(instance.type              ).to eq("Post" ) }
      specify { expect(instance.type(plural: true)).to eq("Posts") }
    end

    describe "#update_counts_for_all" do
      # Empty method
    end

    describe "#sluggable_parts" do
      let(:instance) { create(:minimal_post, title: "Standalone Title") }

      subject { instance.send(:sluggable_parts) }

      it { is_expected.to eq(["Standalone Title"]) }
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.title]) }
    end

    describe "#all_tags" do
      subject { instance.all_tags }

      it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }

      pending "better spec for all_tags"
    end
  end
end
