require 'rails_helper'

RSpec.describe CrudHelper, type: :helper do
  describe "link methods" do
    before(:each) do
      allow(helper).to receive(   :semantic_svg_image).and_return("svg")
      allow(helper).to receive(     :polymorphic_path).and_return("path")
      allow(helper).to receive( :new_polymorphic_path).and_return("path")
      allow(helper).to receive(:edit_polymorphic_path).and_return("path")
    end

    let(   :model) { Creator }
    let(:instance) { create(:minimal_creator) }

    describe "#crud_create_link" do
      it "generates link" do
        expect(helper).to receive(:new_polymorphic_path).with(:admin, model)

        expect(helper.crud_create_link(model)).to eq(
          "<a title=\"new creator\" class=\"crud create\" href=\"path\">svg</a>"
        )
      end
    end

    describe "#crud_destroy_link" do
      it "generates link" do
        expect(helper).to receive(:polymorphic_path).with(:admin, instance)

        expect(helper.crud_destroy_link(instance)).to eq(
          "<a title=\"destroy creator\" class=\"crud destroy\" data-confirm=\"Are you sure?\" rel=\"nofollow\" data-method=\"delete\" href=\"path\">svg</a>"
        )
      end
    end

    describe "#crud_update_link" do
      it "generates link" do
        expect(helper).to receive(:edit_polymorphic_path).with(:admin, instance)

        expect(helper.crud_update_link(instance)).to eq(
          "<a title=\"edit creator\" class=\"crud edit\" href=\"path\">svg</a>"
        )
      end
    end

    describe "#crud_view_link" do
      it "generates link" do
        expect(helper).to receive(:polymorphic_path).with(:admin, instance)

        expect(helper.crud_view_link(instance)).to eq(
          "<a title=\"view creator\" class=\"crud show\" href=\"path\">svg</a>"
        )
      end
    end
  end
end
