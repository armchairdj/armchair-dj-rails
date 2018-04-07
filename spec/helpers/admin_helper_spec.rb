require 'rails_helper'

RSpec.describe AdminHelper, type: :helper do
  describe "link methods" do
    before(:each) do
      allow(helper).to receive(   :semantic_svg_image).and_return("svg")
      allow(helper).to receive(     :polymorphic_path).and_return("path")
      allow(helper).to receive( :new_polymorphic_path).and_return("path")
      allow(helper).to receive(:edit_polymorphic_path).and_return("path")
    end

    let(   :model) { Creator }
    let(:instance) { create(:minimal_creator) }

    describe "#admin_create_link" do
      it "generates link" do
        expect(helper).to receive(:new_polymorphic_path).with(:admin, model)

        expect(helper.admin_create_link(model)).to eq(
          "<a title=\"new creator\" class=\"admin create\" href=\"path\">svg</a>"
        )
      end
    end

    describe "#admin_destroy_link" do
      it "generates link" do
        expect(helper).to receive(:polymorphic_path).with(:admin, instance)

        expect(helper.admin_destroy_link(instance)).to eq(
          "<a title=\"destroy creator\" class=\"admin destroy\" data-confirm=\"Are you sure?\" rel=\"nofollow\" data-method=\"delete\" href=\"path\">svg</a>"
        )
      end
    end

    describe "#admin_update_link" do
      it "generates link" do
        expect(helper).to receive(:edit_polymorphic_path).with(:admin, instance)

        expect(helper.admin_update_link(instance)).to eq(
          "<a title=\"edit creator\" class=\"admin edit\" href=\"path\">svg</a>"
        )
      end
    end

    describe "#admin_view_link" do
      it "generates link" do
        expect(helper).to receive(:polymorphic_path).with(:admin, instance)

        expect(helper.admin_view_link(instance)).to eq(
          "<a title=\"view creator\" class=\"admin show\" href=\"path\">svg</a>"
        )
      end
    end
  end
end
