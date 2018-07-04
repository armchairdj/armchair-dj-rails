# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::MixtapesController, type: :controller do
  let(:mixtape) { create_minimal_instance(:draft) }

  describe "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_linkable_controller"

    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      before(:each) { get :show, params: { id: mixtape.to_param } }

      it { is_expected.to successfully_render("admin/posts/mixtapes/show") }
      it { is_expected.to assign(mixtape, :mixtape) }
    end

    describe "GET #new" do
      before(:each) { get :new }

      it { is_expected.to successfully_render("admin/posts/mixtapes/new") }
      it { is_expected.to prepare_the_mixtape_form }
      it { expect(assigns(:mixtape)).to be_a_populated_new_mixtape }
    end

    describe "POST #create" do
      let(:max_params) { complete_attributes.except(:author_id) }
      let(:min_params) { minimal_attributes.except(:author_id) }
      let(:bad_params) { minimal_attributes.except(:author_id, :playlist_id) }

      context "with max valid params" do
        it "creates a new Mixtape" do
          expect {
            post :create, params: { mixtape: max_params }

          }.to change(Mixtape, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { mixtape: max_params }

          is_expected.to assign(Post.last, :mixtape).with_attributes(max_params).and_be_valid
        end

        it "mixtape belongs to current_user" do
          post :create, params: { mixtape: max_params }

          expect(Post.last.author).to eq(controller.current_user)
        end

        it "redirects to mixtape" do
          post :create, params: { mixtape: max_params }

          is_expected.to send_user_to(
            admin_mixtape_path(assigns(:mixtape))
          ).with_flash(:success, "admin.flash.posts.success.create")
        end
      end

      context "with min valid params" do
        it "creates a new Mixtape" do
          expect {
            post :create, params: { mixtape: min_params }
          }.to change(Mixtape, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { mixtape: min_params }

          is_expected.to assign(Post.last, :mixtape).with_attributes(min_params).and_be_valid
        end

        it "mixtape belongs to current_user" do
          post :create, params: { mixtape: min_params }

          expect(Post.last.author).to eq(controller.current_user)
        end

        it "redirects to mixtape" do
          post :create, params: { mixtape: min_params }

          is_expected.to send_user_to(
            admin_mixtape_path(assigns(:mixtape))
          ).with_flash(:success, "admin.flash.posts.success.create")
        end
      end

      context "with invalid params" do
        before(:each) do
          post :create, params: { mixtape: bad_params }
        end

        it { is_expected.to successfully_render("admin/posts/mixtapes/new") }

        it { is_expected.to prepare_the_mixtape_form }

        it { expect(assigns(:mixtape)).to be_a_populated_new_mixtape }
        it { expect(assigns(:mixtape)).to have_coerced_attributes(bad_params) }
        it { expect(assigns(:mixtape)).to be_invalid }
      end
    end

    describe "GET #edit" do
      before(:each) { get :edit, params: { id: mixtape.to_param } }

      it { is_expected.to successfully_render("admin/posts/mixtapes/edit") }
      it { is_expected.to assign(mixtape, :mixtape) }
      it { is_expected.to prepare_the_mixtape_form }
    end

    describe "PUT #update" do
      let(    :update_params) { { "body" => "New body.", "playlist_id" => create(:minimal_playlist).id } }
      let(:bad_update_params) { { "body" => ""         , "playlist_id" => ""                       } }

      describe "draft" do
        context "with valid params" do
          before(:each) do
            put :update, params: { id: mixtape.to_param, mixtape: update_params }
          end

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(update_params).and_be_valid }
          it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
            :success, "admin.flash.posts.success.update"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { id: mixtape.to_param, mixtape: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/mixtapes/edit") }
          it { is_expected.to assign(mixtape, :mixtape).with_attributes(bad_update_params).and_be_invalid }
          it { is_expected.to prepare_the_mixtape_form }
        end
      end

      describe "publishing" do
        context "with valid params" do
          before(:each) do
            put :update, params: { step: "publish", id: mixtape.to_param, mixtape: update_params }
          end

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:mixtape)).to be_published }

          it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
            :success, "admin.flash.posts.success.publish"
          ) }
        end

        context "with failed transition" do
          before(:each) do
            allow_any_instance_of(Mixtape).to receive(:ready_to_publish?).and_return(false)

            put :update, params: { step: "publish", id: mixtape.to_param, mixtape: update_params }
          end

          it { is_expected.to successfully_render("admin/posts/mixtapes/edit").with_flash(
            :error, "admin.flash.posts.error.publish"
          ) }

          it { is_expected.to prepare_the_mixtape_form }

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(update_params).and_be_valid }

          it { expect(mixtape.reload).to_not be_published }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "publish", id: mixtape.to_param, mixtape: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/mixtapes/edit").with_flash(
            :error, "admin.flash.posts.error.publish"
          ) }

          it { is_expected.to prepare_the_mixtape_form }

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(bad_update_params).with_errors({
            body: :blank,
            playlist: :blank
          }) }

          it { expect(mixtape.reload).to_not be_published }
        end
      end

      describe "unpublishing" do
        let(:mixtape) { create(:minimal_mixtape, :published) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "unpublish", id: mixtape.to_param, mixtape: update_params }
          end

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:mixtape)).to be_draft }

          it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
            :success, "admin.flash.posts.success.unpublish"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "unpublish", id: mixtape.to_param, mixtape: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/mixtapes/edit").with_flash(:error, nil) }

          it { is_expected.to prepare_the_mixtape_form }

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(bad_update_params).with_errors({
            playlist: :blank
          }) }

          it { expect(assigns(:mixtape)).to be_draft }
        end
      end

      describe "scheduling" do
        let(:mixtape) { create(:minimal_mixtape, :draft) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "schedule", id: mixtape.to_param, mixtape: update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:mixtape)).to be_scheduled }

          it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
            :success, "admin.flash.posts.success.schedule"
          ) }
        end

        context "with failed transition" do
          before(:each) do
            allow_any_instance_of(Mixtape).to receive(:ready_to_publish?).and_return(false)

            put :update, params: { step: "schedule", id: mixtape.to_param, mixtape: update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to successfully_render("admin/posts/mixtapes/edit").with_flash(
            :error, "admin.flash.posts.error.schedule"
          ) }

          it { is_expected.to prepare_the_mixtape_form }

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(update_params).and_be_valid }

          it { expect(mixtape.reload).to_not be_scheduled }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "schedule", id: mixtape.to_param, mixtape: bad_update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to successfully_render("admin/posts/mixtapes/edit").with_flash(
            :error, "admin.flash.posts.error.schedule"
          ) }

          it { is_expected.to prepare_the_mixtape_form }

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(bad_update_params).with_errors({
            body: :blank,
            playlist: :blank
          }) }

          it { expect(mixtape.reload).to_not be_scheduled }
        end
      end

      describe "unscheduling" do
        let(:mixtape) { create(:minimal_mixtape, :scheduled) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "unschedule", id: mixtape.to_param, mixtape: update_params }
          end

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:mixtape)).to be_draft }

          it { is_expected.to send_user_to(admin_mixtape_path(mixtape)).with_flash(
            :success, "admin.flash.posts.success.unschedule"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "unschedule", id: mixtape.to_param, mixtape: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/mixtapes/edit").with_flash(:error, nil) }

          it { is_expected.to prepare_the_mixtape_form }

          it { is_expected.to assign(mixtape, :mixtape).with_attributes(bad_update_params).with_errors({
            playlist: :blank
          }) }

          it { expect(assigns(:mixtape)).to be_draft }
        end
      end

      describe "replacing slug" do
        before(:each) { mixtape.update_column(:slug, "old") }

        let(:params) { { "clear_slug" => "1" } }

        it "forces model to update slug" do
          put :update, params: { id: mixtape.to_param, mixtape: params }

          expect(assigns(:mixtape).slug).to_not eq("old")
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:mixtape) { create(:minimal_mixtape) }

      it "destroys the requested mixtape" do
        expect {
          delete :destroy, params: { id: mixtape.to_param }
        }.to change(Mixtape, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: mixtape.to_param }

        is_expected.to send_user_to(admin_mixtapes_path).with_flash(
          :success, "admin.flash.posts.success.destroy"
        )
      end
    end
  end

  describe "helpers" do
    describe "#allowed_scopes" do
      subject { described_class.new.send(:allowed_scopes) }

      specify "keys are short tab names" do
        expect(subject.keys).to match_array([
          "All",
          "Draft",
          "Scheduled",
          "Published",
        ])
      end
    end

    describe "#allowed_sorts" do
      subject { described_class.new.send(:allowed_sorts) }

      specify "keys are short sort names" do
        expect(subject.keys).to match_array([
          "Default",
          "ID",
          "Title",
          "Author",
          "Status",
        ])
      end
    end
  end
end
