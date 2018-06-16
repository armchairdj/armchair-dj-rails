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
    before do
      allow(helper).to receive(     :polymorphic_path).and_return("path")
      allow(helper).to receive( :new_polymorphic_path).and_return("path")
      allow(helper).to receive(:edit_polymorphic_path).and_return("path")

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
      before(:each) do
        expect(helper).to receive(:polymorphic_path).with([:admin, model])
      end

      subject { helper.admin_list_link(model) }

      it { is_expected.to eq('<a title="back to creators list" class="admin list" href="path">list</a>') }
    end

    describe "#admin_view_link" do
      before(:each) do
        expect(helper).to receive(:polymorphic_path).with([:admin, instance])
      end

      subject { helper.admin_view_link(instance) }

      it { is_expected.to eq('<a title="view creator" class="admin view" href="path">view</a>') }
    end

    describe "#admin_create_link" do
      before(:each) do
        expect(helper).to receive(:new_polymorphic_path).with([:admin, model])
      end

      subject { helper.admin_create_link(model) }

      it { is_expected.to eq('<a title="create creator" class="admin create" href="path">create</a>') }
    end

    describe "#admin_update_link" do
      before(:each) do
        expect(helper).to receive(:edit_polymorphic_path).with([:admin, instance])
      end

      subject { helper.admin_update_link(instance) }

      it { is_expected.to eq('<a title="update creator" class="admin edit" href="path">update</a>') }
    end

    describe "#admin_destroy_link" do
      before(:each) do
        expect(helper).to receive(:polymorphic_path).with([:admin, instance])
      end

      subject { helper.admin_destroy_link(instance) }

      it { is_expected.to eq('<a title="destroy creator" class="admin destroy" data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="path">destroy</a>') }
    end

    describe "#admin_public_link" do
      subject { helper.admin_public_link(instance) }

      context "creators" do
        xit "links for viewable" do
          allow(instance).to receive(:viewable?).and_return(true )

          is_expected.to eq('<a title="view creator on site" class="admin public-view" href="path">public</a>')
        end

        xit "nils for non-viewable" do
          allow(instance).to receive(:viewable?).and_return(false)

          is_expected.to eq(nil)
        end
      end
    end
  end

  context "markup generators" do
    pending "#admin_header"
    pending "#admin_actions_cell"
    pending "#admin_index_tabs"
    pending "#admin_column_icon"
    pending "#published_icon"
    pending "#unpublished_icon"
    pending "#post_status_icon"
    pending "#actions_th"
    pending "#sortable_th"
  end
end
