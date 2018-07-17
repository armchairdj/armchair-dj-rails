# frozen_string_literal: true

require "rails_helper"

RSpec.describe Article, type: :model do
  describe "concerns" do
    specify { expect(described_class.superclass).to eq(Post) }
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    let!(      :draft) { create_minimal_instance(:draft    ) }
    let!(  :scheduled) { create_minimal_instance(:scheduled) }
    let!(  :published) { create_minimal_instance(:published) }
    let!(        :ids) { [draft, scheduled, published].map(&:id) }
    let!( :collection) { described_class.where(id: ids) }
    let!(:eager_loads) { [:author, :links, :tags] }

    describe "basics" do
      describe "self#for_show" do
        subject { collection.for_show }

        it { is_expected.to contain_exactly(*collection.to_a) }
        it { is_expected.to eager_load(eager_loads) }
      end

      pending "self#for_list"

      describe "self#for_public" do
        subject { collection.for_public }

        it { is_expected.to eq [published] }
        it { is_expected.to_not eager_load(eager_loads) }
      end
    end
  end

  describe "associations" do
    # Nothing so far.
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:title) }
  end

  describe "instance" do
    let(:instance) { create_minimal_instance }

    describe "#display_type" do
      specify { expect(instance.display_type              ).to eq("Article" ) }
      specify { expect(instance.display_type(plural: true)).to eq("Articles") }
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
