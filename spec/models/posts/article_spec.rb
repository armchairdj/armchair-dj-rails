# frozen_string_literal: true

require "rails_helper"

RSpec.describe Article do
  describe ":Alphabetization" do
    it_behaves_like "an_alphabetizable_model"

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.title]) }
    end
  end

  describe ":GinsuIntegration" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [:author] }
      let(:show_loads) { [:author, :links, :tags] }
    end
  end

  describe ":ImageAttachment" do
    it_behaves_like "an_imageable_model"
  end

  describe ":PublicSite" do
    let!(:tag) { create(:minimal_tag) }

    describe ".related_by_tag" do
      it "returns a reverse-cron relation of up to 3 other published posts with the same tag" do
        expect(described_class).to receive(:for_public).and_call_original

        article, *related = create_minimal_list(4, :published, tag_ids: [tag.id])
        actual = described_class.related_by_tag(article, limit: 2)

        expect(actual).to be_a_kind_of(ActiveRecord::Relation)
        expect(actual).to contain_exactly(*related[1..-1])
      end

      it "returns an empty relation if article has no tags" do
        article = create_minimal_instance
        actual = described_class.related_by_tag(article, limit: 3)

        expect(actual).to eq(described_class.none)
      end
    end

    describe "#related_posts" do
      it "delegates to .related and limits to 3" do
        article = create_minimal_instance

        expect(described_class).to receive(:related_by_tag).with(article, limit: 3)

        article.related_posts
      end
    end
  end

  describe ":SlugAttribute" do
    it_behaves_like "a_sluggable_model"

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.title]) }
    end

    describe "#reset_slug_history" do
      subject(:call_method) { instance.send(:reset_slug_history) }

      let(:instance) do
        instance = create_minimal_instance(:published, title: "foo")
        instance.update!(title: "bar", clear_slug: true)
        instance.update!(title: "bat", clear_slug: true)
        instance
      end

      it "removes all old slugs so they can be reused" do
        expect { call_method }.to change(instance.slugs, :count).from(3).to(0)
      end
    end
  end

  describe ":StiInheritance" do
    specify { expect(described_class.superclass).to eq(Post) }

    describe "type" do
      subject { described_class.new.type }

      it { is_expected.to eq("Article") }
    end

    describe "#display_type" do
      let(:instance) { build_minimal_instance }

      specify { expect(instance.display_type).to eq("Article") }
      specify { expect(instance.display_type(plural: true)).to eq("Articles") }
    end
  end

  describe ":TitleAttribute" do
    it { is_expected.to validate_presence_of(:title) }
  end
end
