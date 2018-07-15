# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminHelper, type: :helper do
  before(:each) do
    allow(helper).to receive(:current_user).and_return(create(:root))
  end

  describe "form methods" do
    pending "#admin_submit_button"
  end

  describe "formatting methods" do
    pending "#admin_post_status"

    pending "#total_count_for"
  end

  describe "link methods" do
    let(   :model) { Creator }
    let(:instance) { create(:minimal_creator) }

    describe "#admin_list_link" do
      before(:each) do
        allow( helper).to receive(:semantic_svg_image).with("open_iconic/list.svg", anything).and_return("list"   )

        allow( helper).to receive(:polymorphic_path).and_return("path")
        expect(helper).to receive(:polymorphic_path).with([:admin, model])
      end

      subject { helper.admin_list_link(model) }

      it { is_expected.to eq('<a title="back to creators list" class="admin list" href="path">list</a>') }
    end

    describe "#admin_view_link" do
      before(:each) do
        allow( helper).to receive(:semantic_svg_image).with("open_iconic/eye.svg", anything).and_return("view"   )

        allow( helper).to receive(:polymorphic_path).and_return("path")
        expect(helper).to receive(:polymorphic_path).with([:admin, instance])
      end

      subject { helper.admin_view_link(instance) }

      it { is_expected.to eq('<a title="view creator" class="admin view" href="path">view</a>') }
    end

    describe "#admin_create_link" do
      before(:each) do
        allow( helper).to receive(:semantic_svg_image).with("open_iconic/plus.svg", anything).and_return("create" )

        allow( helper).to receive(:new_polymorphic_path).and_return("path")
        expect(helper).to receive(:new_polymorphic_path).with([:admin, model])
      end

      subject { helper.admin_create_link(model) }

      it { is_expected.to eq('<a title="create creator" class="admin create" href="path">create</a>') }
    end

    describe "#admin_update_link" do
      before(:each) do
        allow( helper).to receive(:semantic_svg_image).with("open_iconic/pencil.svg", anything).and_return("update" )

        allow( helper).to receive(:edit_polymorphic_path).and_return("path")
        expect(helper).to receive(:edit_polymorphic_path).with([:admin, instance])
      end

      subject { helper.admin_update_link(instance) }

      it { is_expected.to eq('<a title="update creator" class="admin edit" href="path">update</a>') }
    end

    describe "#admin_destroy_link" do
      before(:each) do
        allow( helper).to receive(:semantic_svg_image).with("open_iconic/trash.svg", anything).and_return("destroy")

        allow( helper).to receive(:polymorphic_path).and_return("path")
        expect(helper).to receive(:polymorphic_path).with([:admin, instance])
      end

      subject { helper.admin_destroy_link(instance) }

      it { is_expected.to eq('<a title="destroy creator" class="admin destroy" data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="path">destroy</a>') }
    end

    describe "#admin_public_link" do
      subject { helper.admin_public_link(instance) }

      describe "non-public model" do
        let(:instance) { create(:minimal_creator) }

        it { is_expected.to eq(nil) }
      end

      describe "users" do
        describe "published" do
          before(:each) do
            allow( helper).to receive(:semantic_svg_image).with("open_iconic/link-intact.svg", anything).and_return("public" )

            allow( helper).to receive(:polymorphic_path).and_return("path")
            expect(helper).to receive(:polymorphic_path).with(instance, format: nil)
          end

          let(:instance) { create(:writer, :with_published_post) }
          let(:expected) { "a.admin.public-view[title='view user on site'][href='path']" }

          it { is_expected.to have_tag(expected, text: "public", count: 1) }
        end

        describe "unpublished" do
          let(:instance) { create(:writer, :with_draft_post) }

          it { is_expected.to eq(nil) }
        end

        describe "non-writer" do
          let(:instance) { create(:member) }

          it { is_expected.to eq(nil) }
        end
      end

      describe "posts" do
        describe "published" do
          before(:each) do
            allow( helper).to receive(:semantic_svg_image).with("open_iconic/link-intact.svg", anything).and_return("public" )

            allow( helper).to receive(:article_path).and_return("path")
            expect(helper).to receive(:article_path).with(instance.slug, format: nil)
          end

          let(:instance) { create(:minimal_article, :published) }
          let(:expected) { "a.admin.public-view[title='view article on site'][href='path']" }

          it { is_expected.to have_tag(expected, text: "public", count: 1) }
        end

        describe "scheduled" do
          let(:instance) { create(:minimal_article, :scheduled) }

          it { is_expected.to eq(nil) }
        end

        describe "draft" do
          let(:instance) { create(:minimal_article, :draft) }

          it { is_expected.to eq(nil) }
        end
      end
    end
  end

  describe "markup generators" do
    pending "#admin_header"
    pending "#admin_column_icon"
    pending "#published_icon"
    pending "#unpublished_icon"
    pending "#post_status_icon"
    pending "#sortable_link"
  end
end
