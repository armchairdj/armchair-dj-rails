# frozen_string_literal: true

RSpec.shared_examples "an_admin_post_controller" do
  let(:model_class) { described_class.controller_name.classify.constantize }
  let(:param_key) { model_class.model_name.param_key.to_sym }

  let(:valid_summary) { "summary summary summary summary summary summary" }

  let(:templates) do
    {
      show:    "admin/posts/show",
      new:     "admin/posts/new",
      edit:    "admin/posts/edit",
      preview: "admin/posts/preview"
    }
  end

  def edit_path(instance)
    controller.send(:"edit_admin_#{param_key}_path", instance)
  end

  def show_path(instance)
    controller.send(:"admin_#{param_key}_path", instance)
  end

  def collection_path
    controller.send(:"admin_#{described_class.controller_name}_path")
  end

  let(:min_create_params) { attributes_for_minimal_instance.except(:author_id) }
  let(:bad_create_params) { {} }
  let(:min_update_params) { attributes_for_minimal_instance.except(:author_id) }
  let(:max_update_params) { attributes_for_complete_instance.except(:author_id) }

  def wrap_create_params(params)
    hash = {}
    hash[param_key] = params
    hash
  end

  def wrap_update_params(instance, params, operation = nil)
    hash = { "id" => instance.to_param }

    unless operation.nil?
      params = params.dup

      params[operation.to_s] = "1"
    end

    hash[param_key.to_s] = params

    hash
  end

  context "with root user" do
    login_root

    describe "GET #index" do
      it_behaves_like "a_ginsu_index", "admin/posts/index"
    end

    describe "GET #show" do
      subject { send_request }

      let(:instance) { create_minimal_instance(:draft) }
      let(:send_request) { get :show, params: { id: instance.to_param } }

      it { is_expected.to successfully_render(templates[:show]) }

      it { is_expected.to assign(instance, :post) }
    end

    describe "GET #new" do
      subject { send_request }

      let(:send_request) { get :new }

      it { is_expected.to successfully_render(templates[:new]) }

      describe "instance" do
        subject do
          send_request
          assigns(:post)
        end

        it { is_expected.to be_a_populated_new_post(param_key) }
      end
    end

    describe "POST #create" do
      subject { send_request }

      let(:send_request) { post :create, params: wrap_create_params(params) }

      context "when success" do
        let(:params) { min_create_params }

        it { expect { subject }.to change(Post, :count).by(1) }

        it { is_expected.to send_user_to(edit_path(assigns(:post))) }

        it { is_expected.to have_flash(:success, "admin.flash.posts.success.create") }

        it { is_expected.to assign(Post.last, :post).with_attributes(params).and_be_valid }

        it "assigns current_user as author" do
          send_request

          expect(Post.last.author).to eq(controller.current_user)
        end
      end

      context "with failure" do
        let(:params) { bad_create_params }

        it "sets errors and re-renders new" do
          send_request

          is_expected.to successfully_render(templates[:new])
          expect(assigns(:post)).to be_a_populated_new_post(param_key)
          expect(assigns(:post)).to be_invalid
        end
      end
    end

    describe "GET #edit" do
      subject { send_request }

      let(:instance) { create_minimal_instance(:draft) }
      let(:send_request) { get :edit, params: { id: instance.to_param } }

      it { is_expected.to successfully_render(templates[:edit]) }

      it { is_expected.to assign(instance, :post) }

      it { is_expected.to prepare_the_edit_post_form(param_key) }
    end

    describe "PUT #update" do
      context "with basics" do
        let(:instance) { create_minimal_instance(:draft) }

        before do
          put :update, params: wrap_update_params(instance, params)
        end

        context "with min valid params" do
          let(:params) { min_update_params }

          it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

          it { is_expected.to send_user_to(show_path(instance)) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.update", action: "updated") }
        end

        context "with max valid params" do
          let(:params) { max_update_params }

          it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

          it { is_expected.to send_user_to(show_path(instance)) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.update", action: "updated") }
        end

        context "with invalid params" do
          let(:params) { bad_update_params }

          it { is_expected.to successfully_render(templates[:edit]) }

          it { is_expected.to assign(instance, :post).with_attributes(params).and_be_invalid }

          it { is_expected.to prepare_the_edit_post_form(param_key) }
        end
      end

      context "with status updates" do
        before do
          put :update, params: wrap_update_params(instance, params, transformation)
        end

        context "when publishing" do
          let(:instance) { create_minimal_instance(:draft) }
          let(:transformation) { :publishing }

          context "when valid" do
            let(:params) { { "body" => "body", "summary" => valid_summary } }

            it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

            it { is_expected.to send_user_to(show_path(instance)) }

            it { is_expected.to have_flash(:success, "admin.flash.posts.success.update", action: "updated & published") }

            specify { expect(instance.reload).to be_published }
          end

          pending "invalid"
        end

        context "when unpublishing" do
          let(:instance) { create_minimal_instance(:published) }
          let(:transformation) { :unpublishing }

          context "when valid" do
            let(:params) { { "body" => "body" } }

            it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

            it { is_expected.to send_user_to(show_path(instance)) }

            it { is_expected.to have_flash(:success, "admin.flash.posts.success.update", action: "updated & unpublished") }

            specify { expect(instance.reload).to be_draft }
          end

          pending "invalid"
        end

        context "when scheduling" do
          let(:instance) { create_minimal_instance(:draft) }
          let(:transformation) { :scheduling }

          context "when valid" do
            let(:publish_on) { 3.weeks.from_now }

            let(:params) { { "body" => "body", "summary" => valid_summary, "publish_on" => publish_on } }

            it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

            it { is_expected.to send_user_to(show_path(instance)) }

            it { is_expected.to have_flash(:success, "admin.flash.posts.success.update", action: "updated & scheduled") }

            specify { expect(instance.reload).to be_scheduled }
          end

          pending "invalid"
        end

        context "when unscheduling" do
          let(:instance) { create_minimal_instance(:scheduled) }
          let(:transformation) { :unscheduling }

          context "when valid" do
            let(:params) { { "body" => "body" } }

            it { is_expected.to assign(instance, :post).with_attributes(params).and_be_valid }

            it { is_expected.to send_user_to(show_path(instance)) }

            it { is_expected.to have_flash(:success, "admin.flash.posts.success.update", action: "updated & unscheduled") }

            specify { expect(instance.reload).to be_draft }
          end

          pending "when invalid"
        end
      end

      context "when published" do
        let(:instance) { create_minimal_instance(:published) }

        before do
          put :update, params: wrap_update_params(instance, params)
        end

        context "when replacing slug" do
          let(:params) { { "clear_slug" => "1" } }

          it { is_expected.to send_user_to(show_path(instance)) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.update", action: "updated") }
        end
      end
    end

    describe "PUT #autosave" do
      subject { send_request }

      let!(:instance) { create_minimal_instance(:draft) }
      let(:autosave_params) { { "body" => "autosaved", "summary" => "autosaved" } }
      let(:send_request) { put :autosave, xhr: true, params: wrap_update_params(instance, params) }

      context "with valid params" do
        let(:params) { autosave_params }

        it { is_expected.to render_empty_json_200 }

        it { is_expected.to assign(instance, :post).with_attributes(params) }
      end

      context "with invalid params" do
        let(:params) { bad_update_params }

        it { is_expected.to render_empty_json_200 }

        it "saves without validating" do
          is_expected.to assign(instance, :post).with_attributes(params)
        end
      end

      context "with blacklisted params" do
        let(:params) { { "publish_on" => 3.weeks.from_now, "publishing" => "1" } }

        it { is_expected.to have_http_status(422) }
      end

      context "with failed save" do
        let(:params) { autosave_params }

        before do
          allow_any_instance_of(Post).to receive(:save!).and_raise(StandardError)
        end

        it { is_expected.to render_empty_json_500 }
      end

      context "with non-xhr" do
        let(:params) { autosave_params }
        let(:send_request) { put :autosave, params: wrap_update_params(instance, params) }

        it { is_expected.to render_bad_request }
      end
    end

    pending "PUT #preview"

    describe "DELETE #destroy" do
      subject { send_request }

      let!(:instance) { create_minimal_instance }
      let(:send_request) { delete :destroy, params: { id: instance.to_param } }

      it { expect { subject }.to change(Post, :count).by(-1) }

      it { is_expected.to send_user_to(collection_path) }

      it { is_expected.to have_flash(:success, "admin.flash.posts.success.destroy") }
    end
  end

  context "with admin" do
    pending "cannot destroy"
  end

  context "with editor" do
    pending "cannot destroy"
    pending "cannot publish"
  end

  context "with writer" do
    pending "cannot destroy"
    pending "cannot publish"
    pending "cannot access others' posts"
  end
end
