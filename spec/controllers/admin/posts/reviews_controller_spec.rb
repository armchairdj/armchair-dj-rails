# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::ReviewsController, type: :controller do
  let(:instance) { create_minimal_instance(:draft) }

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
      before(:each) { get :show, params: { id: instance.to_param } }

      it { is_expected.to successfully_render("admin/posts/reviews/show") }
      it { is_expected.to assign(instance, :review) }
    end

    describe "GET #new" do
      before(:each) { get :new }

      it { is_expected.to successfully_render("admin/posts/reviews/new") }
      it { is_expected.to prepare_the_review_form }
      it { expect(assigns(:review)).to be_a_populated_new_review }
    end

    describe "POST #create" do
      let(:max_params) { complete_attributes.except(:author_id) }
      let(:min_params) { minimal_attributes.except(:author_id) }
      let(:bad_params) { minimal_attributes.except(:author_id, :work_id) }

      context "with max valid params" do
        it "creates a new Review" do
          expect {
            post :create, params: { review: max_params }

          }.to change(Review, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { review: max_params }

          is_expected.to assign(Post.last, :review).with_attributes(max_params).and_be_valid
        end

        it "review belongs to current_user" do
          post :create, params: { review: max_params }

          expect(Post.last.author).to eq(controller.current_user)
        end

        it "redirects to review" do
          post :create, params: { review: max_params }

          is_expected.to send_user_to(
            admin_review_path(assigns(:review))
          ).with_flash(:success, "admin.flash.posts.success.create")
        end
      end

      context "with min valid params" do
        it "creates a new Review" do
          expect {
            post :create, params: { review: min_params }
          }.to change(Review, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { review: min_params }

          is_expected.to assign(Post.last, :review).with_attributes(min_params).and_be_valid
        end

        it "review belongs to current_user" do
          post :create, params: { review: min_params }

          expect(Post.last.author).to eq(controller.current_user)
        end

        it "redirects to review" do
          post :create, params: { review: min_params }

          is_expected.to send_user_to(
            admin_review_path(assigns(:review))
          ).with_flash(:success, "admin.flash.posts.success.create")
        end
      end

      context "with invalid params" do
        before(:each) do
          post :create, params: { review: bad_params }
        end

        it { is_expected.to successfully_render("admin/posts/reviews/new") }

        it { is_expected.to prepare_the_review_form }

        it { expect(assigns(:review)).to be_a_populated_new_review }
        it { expect(assigns(:review)).to have_coerced_attributes(bad_params) }
        it { expect(assigns(:review)).to be_invalid }
      end
    end

    describe "GET #edit" do
      before(:each) { get :edit, params: { id: instance.to_param } }

      it { is_expected.to successfully_render("admin/posts/reviews/edit") }
      it { is_expected.to assign(instance, :review) }
      it { is_expected.to prepare_the_review_form }
    end

    describe "PUT #update" do
      let(    :update_params) { { "body" => "New body.", "work_id" => create(:minimal_work).id } }
      let(:bad_update_params) { { "body" => ""         , "work_id" => ""                       } }

      describe "draft" do
        context "with valid params" do
          before(:each) do
            put :update, params: { id: instance.to_param, review: update_params }
          end

          it { is_expected.to assign(instance, :review).with_attributes(update_params).and_be_valid }
          it { is_expected.to send_user_to(admin_review_path(instance)).with_flash(
            :success, "admin.flash.posts.success.update"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { id: instance.to_param, review: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit") }
          it { is_expected.to assign(instance, :review).with_attributes(bad_update_params).and_be_invalid }
          it { is_expected.to prepare_the_review_form }
        end
      end

      describe "publishing" do
        context "with valid params" do
          before(:each) do
            put :update, params: { step: "publish", id: instance.to_param, review: update_params }
          end

          it { is_expected.to assign(instance, :review).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:review)).to be_published }

          it { is_expected.to send_user_to(admin_review_path(instance)).with_flash(
            :success, "admin.flash.posts.success.publish"
          ) }
        end

        context "with failed transition" do
          before(:each) do
            allow_any_instance_of(Review).to receive(:ready_to_publish?).and_return(false)

            put :update, params: { step: "publish", id: instance.to_param, review: update_params }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(
            :error, "admin.flash.posts.error.publish"
          ) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(instance, :review).with_attributes(update_params).and_be_valid }

          it { expect(instance.reload).to_not be_published }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "publish", id: instance.to_param, review: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(
            :error, "admin.flash.posts.error.publish"
          ) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(instance, :review).with_attributes(bad_update_params).with_errors({
            body: :blank,
            work: :blank
          }) }

          it { expect(instance.reload).to_not be_published }
        end
      end

      describe "unpublishing" do
        let(:instance) { create(:minimal_review, :published) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "unpublish", id: instance.to_param, review: update_params }
          end

          it { is_expected.to assign(instance, :review).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:review)).to be_draft }

          it { is_expected.to send_user_to(admin_review_path(instance)).with_flash(
            :success, "admin.flash.posts.success.unpublish"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "unpublish", id: instance.to_param, review: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(:error, nil) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(instance, :review).with_attributes(bad_update_params).with_errors({
            work: :blank
          }) }

          it { expect(assigns(:review)).to be_draft }
        end
      end

      describe "scheduling" do
        let(:instance) { create(:minimal_review, :draft) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "schedule", id: instance.to_param, review: update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to assign(instance, :review).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:review)).to be_scheduled }

          it { is_expected.to send_user_to(admin_review_path(instance)).with_flash(
            :success, "admin.flash.posts.success.schedule"
          ) }
        end

        context "with failed transition" do
          before(:each) do
            allow_any_instance_of(Review).to receive(:ready_to_publish?).and_return(false)

            put :update, params: { step: "schedule", id: instance.to_param, review: update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(
            :error, "admin.flash.posts.error.schedule"
          ) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(instance, :review).with_attributes(update_params).and_be_valid }

          it { expect(instance.reload).to_not be_scheduled }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "schedule", id: instance.to_param, review: bad_update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(
            :error, "admin.flash.posts.error.schedule"
          ) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(instance, :review).with_attributes(bad_update_params).with_errors({
            body: :blank,
            work: :blank
          }) }

          it { expect(instance.reload).to_not be_scheduled }
        end
      end

      describe "unscheduling" do
        let(:instance) { create(:minimal_review, :scheduled) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "unschedule", id: instance.to_param, review: update_params }
          end

          it { is_expected.to assign(instance, :review).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:review)).to be_draft }

          it { is_expected.to send_user_to(admin_review_path(instance)).with_flash(
            :success, "admin.flash.posts.success.unschedule"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "unschedule", id: instance.to_param, review: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(:error, nil) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(instance, :review).with_attributes(bad_update_params).with_errors({
            work: :blank
          }) }

          it { expect(assigns(:review)).to be_draft }
        end
      end

      describe "replacing slug" do
        before(:each) { instance.update_column(:slug, "old") }

        let(:params) { { "clear_slug" => "1" } }

        it "forces model to update slug" do
          put :update, params: { id: instance.to_param, review: params }

          expect(assigns(:review).slug).to_not eq("old")
        end
      end
    end

    describe "PATCH #autosave" do
      let!(:instance) { create(:minimal_review) }
      let(:params) { { "body" => "autosaved", "summary" => "autosaved" } }

      context "success" do
        before(:each) do
          put :autosave, { xhr: true, params: { id: instance.to_param, review: params } }
        end

        describe "with valid params" do
          it { is_expected.to render_empty_json_200 }

          it { is_expected.to assign(instance, :review).with_attributes(params) }
        end

        describe "with invalid params" do
          let(:params) { { "body" => "" } }

          it { is_expected.to render_empty_json_200 }

          it { is_expected.to assign(instance, :review).with_attributes(params) }
        end

        describe "with blacklisted params" do
          let(:params) { { "clear_slug" => "1", "publish_on" => 3.weeks.from_now } }

          it { is_expected.to render_empty_json_200 }

          it "does not regenerate slug" do

          end

          it "does not schedule" do
            expect(instance.reload).to_not be_scheduled
          end
        end
      end

      context "failure" do
        describe "non-xhr" do
          before(:each) do
            put :autosave, params: { id: instance.to_param, review: params }
          end

          it { is_expected.to render_bad_request }
        end

        context "failed save" do
          before(:each) do
            allow_any_instance_of(Review).to receive(:save!).and_raise(StandardError)

            put :autosave, { xhr: true, params: { id: instance.to_param, review: params } }
          end

          it "errors" do
            is_expected.to render_empty_json_500
          end
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:instance) { create(:minimal_review) }

      it "destroys the requested review" do
        expect {
          delete :destroy, params: { id: instance.to_param }
        }.to change(Review, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: instance.to_param }

        is_expected.to send_user_to(admin_reviews_path).with_flash(
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
          "Medium",
        ])
      end
    end
  end
end
