# frozen_string_literal: true

RSpec.shared_examples "an_admin_post_controller" do
  let(:instance) { create_minimal_instance(:draft) }

  let(:model_class) { described_class.controller_name.classify.constantize }
  let(  :view_path) { described_class.controller_name.to_sym }
  let(  :param_key) { model_class.model_name.param_key.to_sym }

  let(:templates) { {
    show: "posts/#{view_path}/show",
    new:  "posts/#{view_path}/new",
    edit: "posts/#{view_path}/edit",
  } }

  def show_path(instance)
    polymorphic_path([:admin, instance])
  end

  def index_path
    polymorphic_path([:admin, model_class])
  end

  def wrap_create_params(params)
    hash = {}
    hash[param_key] = params
    hash
  end

  def wrap_update_params(instance, params, step: nil)
    hash = { "id" => instance.to_param }

    hash[param_key.to_s] = params
    hash["step"        ] = step unless step.nil?

    hash
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      before(:each) { get :show, params: { id: instance.to_param } }

      it { is_expected.to successfully_render(templates[:show]) }

      it { is_expected.to assign(instance, :post) }
    end

    describe "GET #new" do
      before(:each) { get :new }

      it { is_expected.to successfully_render(templates[:new]) }

      it { is_expected.to prepare_the_post_form(param_key) }

      it { expect(assigns(:post)).to be_a_populated_new_post(param_key) }
    end

    describe "POST #create" do
      let(:max_create_params) { complete_attributes.except(:author_id) }
      let(:min_create_params) { minimal_attributes.except(:author_id) }

      context "with max valid params" do
        it "creates a new instance" do
          expect {
            post :create, params: wrap_create_params(max_create_params)
          }.to change(Post, :count).by(1)
        end

        context "results" do
          before(:each) { post :create, params: wrap_create_params(max_create_params) }

          it { is_expected.to send_user_to(show_path(assigns(:post))) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.create") }

          it { is_expected.to assign(Post.last, :post).with_attributes(max_create_params).and_be_valid }

          it { expect(Post.last.author).to eq(controller.current_user) }
        end
      end

      context "with min valid params" do
        it "creates a new instance" do
          expect {
            post :create, params: wrap_create_params(min_create_params)
          }.to change(Post, :count).by(1)
        end

        describe "results" do
          before(:each) { post :create, params: wrap_create_params(min_create_params) }

          it { is_expected.to send_user_to(show_path(assigns(:post))) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.create") }

          it { is_expected.to assign(Post.last, :post).with_attributes(min_create_params).and_be_valid }

          it { expect(Post.last.author).to eq(controller.current_user) }
        end
      end

      context "with invalid params" do
        before(:each) do
          post :create, params: wrap_create_params(bad_create_params)
        end

        it { is_expected.to successfully_render(templates[:new]) }

        it { is_expected.to prepare_the_post_form(param_key) }

        describe "instance" do
          subject { assigns(:post) }

          it { is_expected.to be_a_populated_new_post(param_key) }

          it { is_expected.to have_coerced_attributes(bad_create_params) }

          it { is_expected.to be_invalid }
        end
      end
    end

    describe "GET #edit" do
      before(:each) { get :edit, params: { id: instance.to_param } }

      it { is_expected.to successfully_render(templates[:edit]) }

      it { is_expected.to assign(instance, :post) }

      it { is_expected.to prepare_the_post_form(param_key) }
    end

    describe "PUT #update" do
      describe "draft" do
        context "with valid params" do
          before(:each) do
            put :update, params: wrap_update_params(instance, update_params)
          end

          it { is_expected.to assign(instance, :post).with_attributes(update_params).and_be_valid }

          it { is_expected.to send_user_to(show_path(instance)) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.update") }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: wrap_update_params(instance, bad_update_params)
          end

          it { is_expected.to successfully_render(templates[:edit]) }

          it { is_expected.to assign(instance, :post).with_attributes(bad_update_params).and_be_invalid }

          it { is_expected.to prepare_the_post_form(param_key) }
        end
      end

      describe "publishing" do
        context "with valid params" do
          before(:each) do
            put :update, params: wrap_update_params(instance, update_params, step: "publish")
          end

          it { is_expected.to assign(instance, :post).with_attributes(update_params).and_be_valid }

          it { expect(assigns(:post)).to be_published }

          it { is_expected.to send_user_to(show_path(instance)) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.publish") }
        end

        context "with failed transition" do
          before(:each) do
            allow_any_instance_of(Post).to receive(:ready_to_publish?).and_return(false)

            put :update, params: wrap_update_params(instance, update_params, step: "publish")
          end

          it { is_expected.to successfully_render(templates[:edit]) }

          it { is_expected.to have_flash_now(:error, "admin.flash.posts.error.publish") }

          it { is_expected.to prepare_the_post_form(param_key) }

          it { is_expected.to assign(instance, :post).with_attributes(update_params).and_be_valid }

          it { expect(instance.reload).to_not be_published }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: wrap_update_params(instance, bad_update_params, step: "publish")
          end

          it { is_expected.to successfully_render(templates[:edit]) }

          it { is_expected.to have_flash_now(:error, "admin.flash.posts.error.publish") }

          it { is_expected.to prepare_the_post_form(param_key) }

          it { is_expected.to assign(instance, :post).with_attributes(bad_update_params).with_errors(invalid_publish_errors) }

          it { expect(instance.reload).to_not be_published }
        end
      end

      describe "unpublishing" do
        let(:instance) { create_minimal_instance(:published) }

        context "with valid params" do
          before(:each) do
            put :update, params: wrap_update_params(instance, update_params, step: "unpublish")
          end

          it { expect(assigns(:post)).to be_draft }

          it { is_expected.to assign(instance, :post).with_attributes(update_params).and_be_valid }

          it { is_expected.to send_user_to(show_path(instance)) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.unpublish") }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: wrap_update_params(instance, bad_update_params, step: "unpublish")
          end

          it { expect(assigns(:post)).to be_draft }

          it { is_expected.to successfully_render(templates[:edit]) }

          it { is_expected.to have_flash_now(:error, nil) }

          it { is_expected.to prepare_the_post_form(param_key) }

          it { is_expected.to assign(instance, :post).with_attributes(bad_update_params).with_errors(invalid_unpublish_errors) }
        end
      end

      describe "scheduling" do
        context "with valid params" do
          before(:each) do
            put :update, params: wrap_update_params(instance, update_params.merge(publish_on: 3.weeks.from_now), step: "schedule")
          end

          it { expect(assigns(:post)).to be_scheduled }

          it { is_expected.to assign(instance, :post).with_attributes(update_params).and_be_valid }

          it { is_expected.to send_user_to(show_path(instance)) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.schedule") }
        end

        context "with failed transition" do
          before(:each) do
            allow_any_instance_of(Post).to receive(:ready_to_publish?).and_return(false)

            put :update, params: wrap_update_params(instance, update_params.merge(publish_on: 3.weeks.from_now), step: "schedule")
          end

          it { expect(instance.reload).to_not be_scheduled }

          it { is_expected.to successfully_render(templates[:edit]) } 

          it { is_expected.to have_flash_now(:error, "admin.flash.posts.error.schedule") }

          it { is_expected.to prepare_the_post_form(param_key) }

          it { is_expected.to assign(instance, :post).with_attributes(update_params).and_be_valid }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: wrap_update_params(instance, bad_update_params.merge(publish_on: 3.weeks.from_now), step: "schedule")
          end

          it { expect(instance.reload).to_not be_scheduled }

          it { is_expected.to successfully_render(templates[:edit]) }

          it { is_expected.to have_flash_now(:error, "admin.flash.posts.error.schedule") }

          it { is_expected.to prepare_the_post_form(param_key) }

          it { is_expected.to assign(instance, :post).with_attributes(bad_update_params).with_errors(invalid_publish_errors) }
        end
      end

      describe "unscheduling" do
        let(:instance) { create_minimal_instance(:scheduled) }

        context "with valid params" do
          before(:each) do
            put :update, params: wrap_update_params(instance, update_params, step: "unschedule")
          end

          it { expect(assigns(:post)).to be_draft }

          it { is_expected.to assign(instance, :post).with_attributes(update_params).and_be_valid }

          it { is_expected.to send_user_to(show_path(instance)) }

          it { is_expected.to have_flash(:success, "admin.flash.posts.success.unschedule") }
        end

        context "with invalid params" do
          before(:each) do
            put :update, params: wrap_update_params(instance, bad_update_params, step: "unschedule")
          end

          it { expect(assigns(:post)).to be_draft }

          it { is_expected.to successfully_render(templates[:edit]) }

          it { is_expected.to have_flash_now(:error, nil) }

          it { is_expected.to prepare_the_post_form(param_key) }

          it { is_expected.to assign(instance, :post).with_attributes(bad_update_params).with_errors(invalid_unpublish_errors) }
        end
      end

      describe "replacing slug" do
        before(:each) { instance.update_column(:slug, "old") }

        let(:slug_params) { { "clear_slug" => "1" } }

        it "forces model to update slug" do
          put :update, params: wrap_update_params(instance, slug_params)

          expect(assigns(:post).slug).to_not eq("old")
        end
      end
    end

    describe "PUT #autosave" do
      let!(      :instance) { create_minimal_instance }
      let(:autosave_params) { { "body" => "autosaved", "summary" => "autosaved" } }

      context "success" do
        before(:each) do
          put :autosave, xhr: true, params: wrap_update_params(instance, autosave_params)
        end

        describe "with valid params" do
          it { is_expected.to render_empty_json_200 }

          it { is_expected.to assign(instance, :post).with_attributes(autosave_params) }
        end

        describe "with invalid params" do
          let(:autosave_params) { { "body" => "" } }

          it { is_expected.to render_empty_json_200 }

          it { is_expected.to assign(instance, :post).with_attributes(autosave_params) }
        end

        describe "with blacklisted params" do
          let(:autosave_params) { { "clear_slug" => "1", "publish_on" => 3.weeks.from_now } }

          it { is_expected.to render_empty_json_200 }

          it { expect(instance.reload).to_not be_scheduled }

          pending "does not regenerate slug"
        end
      end

      context "failure" do
        describe "non-xhr" do
          before(:each) do
            put :autosave, params: wrap_update_params(instance, autosave_params)
          end

          it { is_expected.to render_bad_request }
        end

        context "failed save" do
          before(:each) do
            allow_any_instance_of(Post).to receive(:save!).and_raise(StandardError)

            put :autosave, xhr: true, params: wrap_update_params(instance, autosave_params)
          end

          it { is_expected.to render_empty_json_500 }
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:instance) { create_minimal_instance }

      it "destroys the requested post" do
        expect {
          delete :destroy, params: { id: instance.to_param }
        }.to change(Post, :count).by(-1)
      end

      describe "results" do
        before(:each) { delete :destroy, params: { id: instance.to_param } }

        it { is_expected.to send_user_to(index_path) }

        it { is_expected.to have_flash(:success, "admin.flash.posts.success.destroy") }
      end
    end
  end

  context "as admin" do
    pending "cannot destroy"
  end

  context "as editor" do
    pending "cannot destroy"
    pending "cannot publish"
  end

  context "as writer" do
    pending "cannot destroy"
    pending "cannot publish"
    pending "cannot access others' posts"
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
  end
end
