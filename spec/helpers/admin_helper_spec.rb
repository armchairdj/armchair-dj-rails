# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminHelper do
  before do
    allow(helper).to receive(:current_user).and_return(create(:root))
  end

  describe "formatting methods" do
    pending "#admin_post_status"
  end

  describe "link methods" do
    let(:model) { Creator }
    let(:instance) { create(:minimal_creator) }

    describe "#admin_list_link" do
      subject { helper.admin_list_link(model) }

      before do
        expect(helper).to receive(:semantic_svg_image).with("open_iconic/list.svg", anything).and_return("list")
        expect(helper).to receive(:polymorphic_path).with([:admin, model]).and_return("path")
      end

      let(:selector) { "a.admin-icon.list[title='back to creators list'][href='path']" }

      it "has the correct markup" do
        is_expected.to have_tag(selector, text: "list", count: 1)
      end
    end

    describe "#admin_view_link" do
      subject { helper.admin_view_link(instance) }

      before do
        expect(helper).to receive(:semantic_svg_image).with("open_iconic/eye.svg", anything).and_return("view")
        expect(helper).to receive(:polymorphic_path).with([:admin, instance]).and_return("path")
      end

      let(:selector) { "a.admin-icon.view[title='view creator'][href='path']" }

      it "has the correct markup" do
        is_expected.to have_tag(selector, text: "view", count: 1)
      end
    end

    describe "#admin_create_link" do
      subject { helper.admin_create_link(model) }

      before do
        expect(helper).to receive(:semantic_svg_image).with("open_iconic/plus.svg", anything).and_return("create")
        expect(helper).to receive(:new_polymorphic_path).with([:admin, model]).and_return("path")
      end

      let(:selector) { "a.admin-icon.create[title='create creator'][href='path']" }

      it "has the correct markup" do
        is_expected.to have_tag(selector, text: "create", count: 1)
      end
    end

    describe "#admin_update_link" do
      subject { helper.admin_update_link(instance) }

      before do
        expect(helper).to receive(:semantic_svg_image).with("open_iconic/pencil.svg", anything).and_return("update")
        expect(helper).to receive(:edit_polymorphic_path).with([:admin, instance]).and_return("path")
      end

      let(:selector) { "a.admin-icon.update[title='update creator'][href='path']" }

      it "has the correct markup" do
        is_expected.to have_tag(selector, text: "update", count: 1)
      end
    end

    describe "#admin_destroy_link" do
      subject { helper.admin_destroy_link(instance) }

      before do
        expect(helper).to receive(:semantic_svg_image).with("open_iconic/trash.svg", anything).and_return("destroy")
        expect(helper).to receive(:polymorphic_path).with([:admin, instance]).and_return("path")
      end

      let(:selector) { "a.admin-icon.destroy[title='destroy creator'][href='path'][data-method='delete'][data-confirm][rel='nofollow']" }

      it "has the correct markup" do
        is_expected.to have_tag(selector, text: "destroy", count: 1)
      end
    end

    describe "#admin_public_link" do
      subject { helper.admin_public_link(instance) }

      describe "non-public model" do
        let(:instance) { create(:minimal_creator) }

        it { is_expected.to eq(nil) }
      end

      describe "published users" do
        before do
          expect(helper).to receive(:semantic_svg_image).with("open_iconic/link-intact.svg", anything).and_return("public")
          expect(helper).to receive(:polymorphic_path).with(instance, format: nil).and_return("path")
        end

        let(:instance) { create(:writer, :with_published_post) }
        let(:selector) { "a.admin-icon.public-view[title='view user on site'][href='path']" }

        it "has the correct markup" do
          is_expected.to have_tag(selector, text: "public", count: 1)
        end
      end

      describe "unpublished users" do
        let(:instance) { create(:writer, :with_draft_post) }

        it { is_expected.to eq(nil) }
      end

      describe "non-writer users" do
        let(:instance) { create(:member) }

        it { is_expected.to eq(nil) }
      end

      describe "published posts" do
        before do
          expect(helper).to receive(:semantic_svg_image).with("open_iconic/link-intact.svg", anything).and_return("public")
          expect(helper).to receive(:article_path).with(instance.slug, format: nil).and_return("path")
        end

        let(:instance) { create(:minimal_article, :published) }
        let(:expected) { "a.admin-icon.public-view[title='view article on site'][href='path']" }

        it "has the correct markup" do
          is_expected.to have_tag(expected, text: "public", count: 1)
        end
      end

      describe "scheduled posts" do
        let(:instance) { create(:minimal_article, :scheduled) }

        it { is_expected.to eq(nil) }
      end

      describe "draft posts" do
        let(:instance) { create(:minimal_article, :draft) }

        it { is_expected.to eq(nil) }
      end
    end
  end

  describe "markup generators" do
    pending "#status_icon_header"
    pending "#sortable_link"
  end
end
