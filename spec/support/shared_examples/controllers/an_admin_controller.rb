# frozen_string_literal: true

RSpec.shared_examples "an_admin_controller" do
  let(:model_instance) { create_minimal_instance }

  context "included" do
    context "callbacks" do
      context "before_action" do
        describe "#is_admin" do
          before(:each) do
            allow(controller).to receive(:is_admin)
            expect(controller).to receive(:is_admin)
          end

          specify { get    :index  }
          specify { get    :new    }
          specify { post   :create }
          specify { get    :show,    params: { id: model_instance.id} }
          specify { get    :edit,    params: { id: model_instance.id} }
          specify { patch  :update,  params: { id: model_instance.id} }
          specify { delete :destroy, params: { id: model_instance.id} }
        end
      end
    end
  end

  context "instance" do
    context "private" do
      describe "#determine_layout" do
        specify { expect(controller.send(:determine_layout)).to eq("admin") }
      end

      describe "#is_admin" do
        it "sets instance var for use in view" do
          controller.send(:is_admin)

          expect(assigns(:admin)).to eq(true)
        end
      end

      pending "#scoped_and_sorted_collection"
    end
  end
end
