# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::ArticlesController, type: :controller do
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

      it { is_expected.to successfully_render("admin/posts/articles/show") }
      it { is_expected.to assign(instance, :article) }
    end

    describe "GET #new" do
      before(:each) { get :new }

      it { is_expected.to successfully_render("admin/posts/articles/new") }
      it { is_expected.to prepare_the_article_form }
      it { expect(assigns(:article)).to be_a_populated_new_article }
    end

    describe "POST #create" do
      let(:max_params) { complete_attributes.except(:author_id) }
      let(:min_params) { minimal_attributes.except(:author_id) }
      let(:bad_params) { minimal_attributes.except(:author_id, :title) }

      context "with max valid params" do
        it "creates a new Article" do
          expect {
            post :create, params: { article: max_params }
          }.to change(Article, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { article: max_params }

          is_expected.to assign(Post.last, :article).with_attributes(max_params).and_be_valid
        end

        it "article belongs to current_user" do
          post :create, params: { article: max_params }

          expect(Post.last.author).to eq(controller.current_user)
        end

        it "redirects to article" do
          post :create, params: { article: max_params }

          is_expected.to send_user_to(
            admin_article_path(assigns(:article))
          ).with_flash(:success, "admin.flash.posts.success.create")
        end
      end

      context "with min valid params" do
        it "creates a new Article" do
          expect {
            post :create, params: { article: min_params }
          }.to change(Article, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { article: min_params }

          is_expected.to assign(Post.last, :article).with_attributes(min_params).and_be_valid
        end

        it "article belongs to current_user" do
          post :create, params: { article: min_params }

          expect(Post.last.author).to eq(controller.current_user)
        end

        it "redirects to article" do
          post :create, params: { article: min_params }

          is_expected.to send_user_to(
            admin_article_path(assigns(:article))
          ).with_flash(:success, "admin.flash.posts.success.create")
        end
      end

      context "with invalid params" do
        before(:each) do
          post :create, params: { article: bad_params }
        end

        it { is_expected.to successfully_render("admin/posts/articles/new") }

        it { is_expected.to prepare_the_article_form }

        it { expect(assigns(:article)).to be_a_populated_new_article }
        it { expect(assigns(:article)).to have_coerced_attributes(bad_params) }
        it { expect(assigns(:article)).to be_invalid }
      end
    end

    describe "GET #edit" do
      before(:each) { get :edit, params: { id: instance.to_param } }

      it { is_expected.to successfully_render("admin/posts/articles/edit") }
      it { is_expected.to assign(instance, :article) }
      it { is_expected.to prepare_the_article_form }
    end

    describe "PUT #update" do
      let(    :update_params) { { "body" => "New body.", "title" => "New title." } }
      let(:bad_update_params) { { "body" => ""         , "title" => ""           } }

      describe "draft" do
        context "with valid params" do
          before(:each) do
            put :update, params: { id: instance.to_param, article: update_params }
          end

          it { is_expected.to assign(instance, :article).with_attributes(update_params).and_be_valid }
          it { is_expected.to send_user_to(admin_article_path(instance)).with_flash(
            :success, "admin.flash.posts.success.update"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { id: instance.to_param, article: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/articles/edit") }
          it { is_expected.to assign(instance, :article).with_attributes(bad_update_params).and_be_invalid }
          it { is_expected.to prepare_the_article_form }
        end
      end

      describe "publishing" do
        context "with valid params" do
          before(:each) do
            put :update, params: { step: "publish", id: instance.to_param, article: update_params }
          end

          it { is_expected.to assign(instance, :article).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:article)).to be_published }

          it { is_expected.to send_user_to(admin_article_path(instance)).with_flash(
            :success, "admin.flash.posts.success.publish"
          ) }
        end

        context "with failed transition" do
          before(:each) do
            allow_any_instance_of(Article).to receive(:ready_to_publish?).and_return(false)

            put :update, params: { step: "publish", id: instance.to_param, article: update_params }
          end

          it { is_expected.to successfully_render("admin/posts/articles/edit").with_flash(
            :error, "admin.flash.posts.error.publish"
          ) }

          it { is_expected.to prepare_the_article_form }

          it { is_expected.to assign(instance, :article).with_attributes(update_params).and_be_valid }

          it { expect(instance.reload).to_not be_published }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "publish", id: instance.to_param, article: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/articles/edit").with_flash(
            :error, "admin.flash.posts.error.publish"
          ) }

          it { is_expected.to prepare_the_article_form }

          it { is_expected.to assign(instance, :article).with_attributes(bad_update_params).with_errors({
            body:  :blank,
            title: :blank
          }) }

          it { expect(instance.reload).to_not be_published }
        end
      end

      describe "unpublishing" do
        let(:instance) { create(:minimal_article, :published) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "unpublish", id: instance.to_param, article: update_params }
          end

          it { is_expected.to assign(instance, :article).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:article)).to be_draft }

          it { is_expected.to send_user_to(admin_article_path(instance)).with_flash(
            :success, "admin.flash.posts.success.unpublish"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "unpublish", id: instance.to_param, article: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/articles/edit").with_flash(:error, nil) }

          it { is_expected.to prepare_the_article_form }

          it { is_expected.to assign(instance, :article).with_attributes(bad_update_params).with_errors({
            title: :blank
          }) }

          it { expect(assigns(:article)).to be_draft }
        end
      end

      describe "scheduling" do
        let(:instance) { create(:minimal_article, :draft) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "schedule", id: instance.to_param, article: update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to assign(instance, :article).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:article)).to be_scheduled }

          it { is_expected.to send_user_to(admin_article_path(instance)).with_flash(
            :success, "admin.flash.posts.success.schedule"
          ) }
        end

        context "with failed transition" do
          before(:each) do
            allow_any_instance_of(Article).to receive(:ready_to_publish?).and_return(false)

            put :update, params: { step: "schedule", id: instance.to_param, article: update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to successfully_render("admin/posts/articles/edit").with_flash(
            :error, "admin.flash.posts.error.schedule"
          ) }

          it { is_expected.to prepare_the_article_form }

          it { is_expected.to assign(instance, :article).with_attributes(update_params).and_be_valid }

          it { expect(instance.reload).to_not be_scheduled }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "schedule", id: instance.to_param, article: bad_update_params.merge(publish_on: 3.weeks.from_now) }
          end

          it { is_expected.to successfully_render("admin/posts/articles/edit").with_flash(
            :error, "admin.flash.posts.error.schedule"
          ) }

          it { is_expected.to prepare_the_article_form }

          it { is_expected.to assign(instance, :article).with_attributes(bad_update_params).with_errors({
            body:  :blank,
            title: :blank
          }) }

          it { expect(instance.reload).to_not be_scheduled }
        end
      end

      describe "unscheduling" do
        let(:instance) { create(:minimal_article, :scheduled) }

        context "with valid params" do
          before(:each) do
            put :update, params: { step: "unschedule", id: instance.to_param, article: update_params }
          end

          it { is_expected.to assign(instance, :article).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:article)).to be_draft }

          it { is_expected.to send_user_to(admin_article_path(instance)).with_flash(
            :success, "admin.flash.posts.success.unschedule"
          ) }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: { step: "unschedule", id: instance.to_param, article: bad_update_params }
          end

          it { is_expected.to successfully_render("admin/posts/articles/edit").with_flash(:error, nil) }

          it { is_expected.to prepare_the_article_form }

          it { is_expected.to assign(instance, :article).with_attributes(bad_update_params).with_errors({
            title: :blank
          }) }

          it { expect(assigns(:article)).to be_draft }
        end
      end

      describe "replacing slug" do
        before(:each) { instance.update_column(:slug, "old") }

        let(:params) { { "clear_slug" => "1" } }

        it "forces model to update slug" do
          put :update, params: { id: instance.to_param, article: params }

          expect(assigns(:article).slug).to_not eq("old")
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:instance) { create(:minimal_article) }

      it "destroys the requested article" do
        expect {
          delete :destroy, params: { id: instance.to_param }
        }.to change(Article, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: instance.to_param }

        is_expected.to send_user_to(admin_articles_path).with_flash(
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
