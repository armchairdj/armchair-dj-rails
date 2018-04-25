require "rails_helper"

RSpec.describe AdminHelper, type: :helper do
  describe "form methods" do
    pending "#admin_submit_button"
  end

  describe "formatting methods" do
    describe "#admin_date" do
      it "formats dates consistently" do
        Timecop.freeze(2050, 3, 3) do
          expect(helper.admin_date DateTime.now).to eq(
            '<time datetime="2050-03-02T16:00:00-08:00">03/02/2050 at 04:00PM</time>'
          )
        end
      end
    end
  end

  describe "link methods" do
    before(:each) do
      allow(helper).to receive(     :polymorphic_path).and_return("path")
      allow(helper).to receive( :new_polymorphic_path).and_return("path")
      allow(helper).to receive(:edit_polymorphic_path).and_return("path")
      allow(helper).to receive(  :post_permalink_path).and_return("path")

      allow(helper).to receive(   :semantic_svg_image).with("open_iconic/plus.svg",        anything).and_return("create")
      allow(helper).to receive(   :semantic_svg_image).with("open_iconic/trash.svg",       anything).and_return("destroy")
      allow(helper).to receive(   :semantic_svg_image).with("open_iconic/list.svg",        anything).and_return("list")
      allow(helper).to receive(   :semantic_svg_image).with("open_iconic/link-intact.svg", anything).and_return("public")
      allow(helper).to receive(   :semantic_svg_image).with("open_iconic/pencil.svg",      anything).and_return("update")
      allow(helper).to receive(   :semantic_svg_image).with("open_iconic/eye.svg",         anything).and_return("view")
    end

    let(   :model) { Creator }
    let(:instance) { create(:minimal_creator) }

    describe "#admin_create_link" do
      it "generates link" do
        expect(helper).to receive(:new_polymorphic_path).with([:admin, model])

        expect(helper.admin_create_link(model)).to eq(
          '<a title="create creator" class="admin create" href="path">create</a>'
        )
      end
    end

    describe "#admin_destroy_link" do
      it "generates link" do
        expect(helper).to receive(:polymorphic_path).with([:admin, instance])

        expect(helper.admin_destroy_link(instance)).to eq(
          '<a title="destroy creator" class="admin destroy" data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="path">destroy</a>'
        )
      end
    end

    describe "#admin_list_link" do
      it "generates link" do
        expect(helper).to receive(:polymorphic_path).with([:admin, model])

        expect(helper.admin_list_link(model)).to eq(
          '<a title="back to creators list" class="admin list" href="path">list</a>'
        )
      end
    end

    describe "#admin_public_creator_link" do
      it "generates link" do
        post     = create(:song_review, :published)
        instance = post.work.creators.first

        expect(helper).to receive(:polymorphic_path).with(instance)

        expect(helper.admin_public_creator_link(instance)).to eq(
          '<a title="view creator on site" class="admin public-view" target="_blank" href="path">public</a>'
        )
      end

      it "nils unless published posts" do
        post     = create(:song_review)
        instance = post.work.creators.first

        expect(helper).to_not receive(:polymorphic_path)

        expect(helper.admin_public_creator_link(instance)).to eq(nil)
      end
    end

    describe "#admin_public_post_link" do
      it "generates link" do
        instance = create(:song_review, :published)

        expect(helper).to receive(:post_permalink_path).with(slug: instance.slug)

        expect(helper.admin_public_post_link(instance)).to eq(
          '<a title="view post on site" class="admin public-view" target="_blank" href="path">public</a>'
        )
      end

      it "nils unless published" do
        instance = create(:song_review)

        expect(helper).to_not receive(:post_permalink_path)

        expect(helper.admin_public_post_link(instance)).to eq(nil)
      end
    end

    describe "#admin_public_work_link" do
      it "generates link" do
        post     = create(:song_review, :published)
        instance = post.work

        expect(helper).to receive(:polymorphic_path).with(instance)

        expect(helper.admin_public_work_link(instance)).to eq(
          '<a title="view work on site" class="admin public-view" target="_blank" href="path">public</a>'
        )
      end

      it "nils unless published posts" do
        post     = create(:song_review)
        instance = post.work

        expect(helper).to_not receive(:polymorphic_path)

        expect(helper.admin_public_work_link(instance)).to eq(nil)
      end
    end

    describe "#admin_public_link" do
      it "generates link" do
        post     = create(:song_review, :published)
        instance = post.work

        expect(helper).to receive(:polymorphic_path).with(instance)

        expect(helper.admin_public_link(instance)).to eq(
          '<a title="view work on site" class="admin public-view" target="_blank" href="path">public</a>'
        )
      end

      it "overrides url" do
        post     = create(:song_review, :published)
        instance = post.work

        expect(helper).to_not receive(:polymorphic_path)

        expect(helper.admin_public_link(instance, "/")).to eq(
          '<a title="view work on site" class="admin public-view" target="_blank" href="/">public</a>'
        )
      end
    end

    describe "#admin_update_link" do
      it "generates link" do
        expect(helper).to receive(:edit_polymorphic_path).with([:admin, instance])

        expect(helper.admin_update_link(instance)).to eq(
          '<a title="update creator" class="admin edit" href="path">update</a>'
        )
      end
    end

    describe "#admin_view_link" do
      it "generates link" do
        expect(helper).to receive(:polymorphic_path).with([:admin, instance])

        expect(helper.admin_view_link(instance)).to eq(
          '<a title="view creator" class="admin view" href="path">view</a>'
        )
      end
    end
  end
end
