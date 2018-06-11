# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminHelper, type: :helper do
  before(:each) do
    allow(helper).to receive(:current_user).and_return(create(:root))
  end

  context "form methods" do
    pending "#admin_submit_button"
  end

  context "formatting methods" do
    describe "#admin_date" do
      it "formats dates consistently" do
        Timecop.freeze(2050, 3, 3) do
          expect(helper.admin_date DateTime.now).to eq(
            '<time datetime="2050-03-02T16:00:00-08:00">03/02/2050 at 04:00PM</time>'
          )
        end
      end
    end

    pending "#total_count_for"
  end

  context "link methods" do
    before(:each) do
      allow(helper).to receive(     :polymorphic_path).and_return("path")
      allow(helper).to receive( :new_polymorphic_path).and_return("path")
      allow(helper).to receive(:edit_polymorphic_path).and_return("path")
      allow(helper).to receive(  :article_permalink_path).and_return("path")

      allow(helper).to receive(:semantic_svg_image).with("open_iconic/plus.svg",        anything).and_return("create" )
      allow(helper).to receive(:semantic_svg_image).with("open_iconic/trash.svg",       anything).and_return("destroy")
      allow(helper).to receive(:semantic_svg_image).with("open_iconic/list.svg",        anything).and_return("list"   )
      allow(helper).to receive(:semantic_svg_image).with("open_iconic/link-intact.svg", anything).and_return("public" )
      allow(helper).to receive(:semantic_svg_image).with("open_iconic/pencil.svg",      anything).and_return("update" )
      allow(helper).to receive(:semantic_svg_image).with("open_iconic/eye.svg",         anything).and_return("view"   )
    end

    let(   :model) { Creator }
    let(:instance) { create(:minimal_creator) }

    describe "#admin_list_link" do
      it "generates link" do
        expect(helper).to receive(:polymorphic_path).with([:admin, model])

        expect(helper.admin_list_link(model)).to eq(
          '<a title="back to creators list" class="admin list" href="path">list</a>'
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

    describe "#admin_create_link" do
      it "generates link" do
        expect(helper).to receive(:new_polymorphic_path).with([:admin, model])

        expect(helper.admin_create_link(model)).to eq(
          '<a title="create creator" class="admin create" href="path">create</a>'
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

    describe "#admin_destroy_link" do
      it "generates link" do
        expect(helper).to receive(:polymorphic_path).with([:admin, instance])

        expect(helper.admin_destroy_link(instance)).to eq(
          '<a title="destroy creator" class="admin destroy" data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="path">destroy</a>'
        )
      end
    end

    describe "#admin_public_link" do
      subject { helper.admin_public_link(instance) }

      context "creators" do
        let(:instance) { create(:minimal_creator) }

        describe "viewable" do
          before(:each) do
            allow(instance).to receive(:viewable?             ).and_return(true       )
            allow(helper  ).to receive(:creator_permalink_path).and_return("permalink")
          end

          it { is_expected.to eq('<a title="view creator on site" class="admin public-view" href="permalink">public</a>') }
        end

        describe "non-viewable" do
          before(:each) do
            allow(instance).to receive(:viewable?).and_return(false)
          end

          it { is_expected.to eq(nil) }
        end
      end

      context "articles" do
        let(:instance) { create(:minimal_article) }

        describe "published" do
          before(:each) do
            allow(instance).to receive(:published?         ).and_return(true       )
            allow(helper  ).to receive(:article_permalink_path).and_return("permalink")
          end

          it { is_expected.to eq('<a title="view article on site" class="admin public-view" href="permalink">public</a>') }
        end

        describe "unpublished" do
          before(:each) do
            allow(instance).to receive(:published?).and_return(false)
          end

          it { is_expected.to eq(nil) }
        end
      end

      context "tags" do
        let(:instance) { create(:minimal_tag) }

        describe "viewable" do
          before(:each) do
            allow(instance).to receive(:viewable?             ).and_return(true       )
            allow(helper  ).to receive(:tag_permalink_path).and_return("permalink")
          end

          it { is_expected.to eq('<a title="view tag on site" class="admin public-view" href="permalink">public</a>') }
        end

        describe "non-viewable" do
          before(:each) do
            allow(instance).to receive(:viewable?).and_return(false)
          end

          it { is_expected.to eq(nil) }
        end
      end

      context "users" do
        let(:instance) { create(:minimal_user) }

        describe "viewable" do
          before(:each) do
            allow(instance).to receive(:viewable?        ).and_return(true     )
            allow(helper  ).to receive(:user_profile_path).and_return("profile")
          end

          it { is_expected.to eq('<a title="view user on site" class="admin public-view" href="profile">public</a>') }
        end

        describe "non-viewable" do
          before(:each) do
            allow(instance).to receive(:viewable?).and_return(false)
          end

          it { is_expected.to eq(nil) }
        end
      end

      context "works" do
        let(:instance) { create(:minimal_song) }

        describe "viewable" do
          before(:each) do
            allow(instance).to receive(:viewable?          ).and_return(true       )
            allow(helper  ).to receive(:work_permalink_path).and_return("permalink")
          end

          it { is_expected.to eq('<a title="view work on site" class="admin public-view" href="permalink">public</a>') }
        end

        describe "non-viewable" do
          before(:each) do
            allow(instance).to receive(:viewable?).and_return(false)
          end

          it { is_expected.to eq(nil) }
        end
      end
    end
  end

  context "markup generators" do
    pending "#admin_header"
    pending "#admin_actions_cell"
    pending "#admin_index_tabs"
    pending "#admin_column_icon"
    pending "#viewable_icon"
    pending "#unviewable_icon"
    pending "#post_status_icon"
    pending "#actions_th"
    pending "#sortable_th"
  end
end
