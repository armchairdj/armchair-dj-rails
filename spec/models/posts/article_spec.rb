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
    describe "#related_posts" do
      let!(:tag) { create(:minimal_tag) }

      it "returns a reverse-cron relation of up to 3 other published articles with the same tag" do
        expect(described_class).to receive(:for_public).and_call_original

        article, *related = create_minimal_list(5, :published, tag_ids: [tag.id])

        expect(article.related_posts).to contain_exactly(related[1], related[2], related[3])
      end

      it "returns an empty relation if article has no tags" do
        expect(create_minimal_instance.related_posts).to be_empty
      end

      it "returns an empty relation if no other published posts with the same tag" do
        article, _related = create_minimal_list(2, :draft, tag_ids: [tag.id])

        article.publish!

        expect(article.related_posts).to be_empty
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
