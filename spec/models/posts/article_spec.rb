# frozen_string_literal: true

require "rails_helper"

RSpec.describe Article, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_linkable_model"

    it_behaves_like "a_post"

    it_behaves_like "a_sluggable_model"

    it_behaves_like "a_summarizable_model"
  end

  context "class" do
    # Nothing so far.
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

        it { is_expected.to eager_load(:author, :tags) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        it { is_expected.to contain_exactly(draft, scheduled, published) }

        it { is_expected.to eager_load(:author, :tags) }
      end

      describe "self#for_site" do
        subject { collection.for_site }

        it { is_expected.to eq [published] }

        it { is_expected.to eager_load(:author, :tags) }
      end
    end
  end

  context "associations" do
    # Nothing so far.
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:title) }
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#type" do
      specify { expect(instance.type              ).to eq("Article" ) }
      specify { expect(instance.type(plural: true)).to eq("Articles") }
    end

    describe "#cascade_viewable" do
      # Empty method
    end

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      it { is_expected.to eq([instance.title]) }
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.title]) }
    end
  end
end
