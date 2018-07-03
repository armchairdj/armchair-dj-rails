# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::ReviewsController, type: :controller do
  let(:review) { create_minimal_instance(:draft) }

  context "concerns" do
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
      before(:each) { get :show, params: { id: review.to_param } }

      it { is_expected.to successfully_render("admin/posts/reviews/show") }
      it { is_expected.to assign(review, :review) }
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
      before(:each) { get :edit, params: { id: review.to_param } }

      it { is_expected.to successfully_render("admin/posts/reviews/edit") }
      it { is_expected.to assign(review, :review) }
      it { is_expected.to prepare_the_review_form }
    end

    describe "PUT #update" do
      let(    :update_params) { { "body" => "New body.", "work_id" => create(:minimal_work).id } }
      let(:bad_update_params) { { "body" => ""         , "work_id" => ""                       } }

      context "draft" do
        context "with valid params" do
          before(:each) do
            put :update, params: { id: review.to_param, review: update_params }
          end

          it { is_expected.to assign(review, :review).with_attributes(update_params).and_be_valid }
          it { is_expected.to send_user_to(admin_review_path(review)).with_flash(
            :success, "admin.flash.posts.success.update"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { id: review.to_param, review: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit") }
          it { is_expected.to assign(review, :review).with_attributes(bad_update_params).and_be_invalid }
          it { is_expected.to prepare_the_review_form }
        end
      end

      context "publishing" do
        context "with valid params" do
          before(:each) do
            put :update, params: { step: "publish", id: review.to_param, review: update_params }
          end

          it { is_expected.to assign(review, :review).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:review)).to be_published }

          it { is_expected.to send_user_to(admin_review_path(review)).with_flash(
            :success, "admin.flash.posts.success.publish"
          ) }
        end

        context "with failed transition" do
          before(:each) do
            allow_any_instance_of(Review).to receive(:ready_to_publish?).and_return(false)

            put :update, params: { step: "publish", id: review.to_param, review: update_params }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(
            :error, "admin.flash.posts.error.publish"
          ) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(review, :review).with_attributes(update_params).and_be_valid }

          it { expect(review.reload).to_not be_published }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "publish", id: review.to_param, review: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(
            :error, "admin.flash.posts.error.publish"
          ) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(review, :review).with_attributes(bad_update_params).with_errors({
            body: :blank,
            work: :blank
          }) }

          it { expect(review.reload).to_not be_published }
        end
      end

      context "unpublishing" do
        let(:review) { create(:minimal_review, :published) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "unpublish", id: review.to_param, review: update_params }
          end

          it { is_expected.to assign(review, :review).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:review)).to be_draft }

          it { is_expected.to send_user_to(admin_review_path(review)).with_flash(
            :success, "admin.flash.posts.success.unpublish"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "unpublish", id: review.to_param, review: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(:error, nil) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(review, :review).with_attributes(bad_update_params).with_errors({
            work: :blank
          }) }

          it { expect(assigns(:review)).to be_draft }
        end
      end

      context "scheduling" do
        let(:review) { create(:minimal_review, :draft) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "schedule", id: review.to_param, review: update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to assign(review, :review).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:review)).to be_scheduled }

          it { is_expected.to send_user_to(admin_review_path(review)).with_flash(
            :success, "admin.flash.posts.success.schedule"
          ) }
        end

        context "with failed transition" do
          before(:each) do
            allow_any_instance_of(Review).to receive(:ready_to_publish?).and_return(false)

            put :update, params: { step: "schedule", id: review.to_param, review: update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(
            :error, "admin.flash.posts.error.schedule"
          ) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(review, :review).with_attributes(update_params).and_be_valid }

          it { expect(review.reload).to_not be_scheduled }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "schedule", id: review.to_param, review: bad_update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(
            :error, "admin.flash.posts.error.schedule"
          ) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(review, :review).with_attributes(bad_update_params).with_errors({
            body: :blank,
            work: :blank
          }) }

          it { expect(review.reload).to_not be_scheduled }
        end
      end

      context "unscheduling" do
        let(:review) { create(:minimal_review, :scheduled) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "unschedule", id: review.to_param, review: update_params }
          end

          it { is_expected.to assign(review, :review).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:review)).to be_draft }

          it { is_expected.to send_user_to(admin_review_path(review)).with_flash(
            :success, "admin.flash.posts.success.unschedule"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "unschedule", id: review.to_param, review: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/reviews/edit").with_flash(:error, nil) }

          it { is_expected.to prepare_the_review_form }

          it { is_expected.to assign(review, :review).with_attributes(bad_update_params).with_errors({
            work: :blank
          }) }

          it { expect(assigns(:review)).to be_draft }
        end
      end

      context "replacing slug" do
        before(:each) { review.update_column(:slug, "old") }

        let(:params) { { "clear_slug" => "1" } }

        it "forces model to update slug" do
          put :update, params: { id: review.to_param, review: params }

          expect(assigns(:review).slug).to_not eq("old")
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:review) { create(:minimal_review) }

      it "destroys the requested review" do
        expect {
          delete :destroy, params: { id: review.to_param }
        }.to change(Review, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: review.to_param }

        is_expected.to send_user_to(admin_reviews_path).with_flash(
          :success, "admin.flash.posts.success.destroy"
        )
      end
    end
  end

  context "helpers" do
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
