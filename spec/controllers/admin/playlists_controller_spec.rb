# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PlaylistsController, type: :controller do
  let(:instance) { create(:minimal_playlist) }

  describe "concerns" do
    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      # it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      subject do
        get :show, params: { id: instance.to_param }
      end

      it { is_expected.to successfully_render("admin/playlists/show") }

      it { is_expected.to assign(instance, :playlist) }
    end

    describe "GET #new" do
      let(:operation) { get :new }

      subject { operation }

      it { is_expected.to successfully_render("admin/playlists/new") }

      describe "instance" do
        subject { operation; assigns(:playlist) }

        it { is_expected.to be_a_new(Playlist) }
      end
    end

    describe "POST #create" do
      let(:min_params) { attributes_for(:minimal_playlist ).except(:author_id) }
      let(:max_params) { attributes_for(:complete_playlist).except(:author_id) }
      let(:bad_params) { attributes_for(:minimal_playlist ).except(:author_id, :title) }

      context "with min valid params" do
        subject { post :create, params: { playlist: min_params } }

        it { expect { subject }.to change { Playlist.count }.by(1) }

        it { is_expected.to assign(Playlist.last, :playlist).with_attributes(min_params).and_be_valid }

        it { is_expected.to send_user_to(admin_playlist_path(assigns(:playlist))) }

        it { is_expected.to have_flash(:success, "admin.flash.playlists.success.create") }

        it { subject; expect(Playlist.last.author).to eq(controller.current_user) }
      end

      context "with max valid params" do
        subject { post :create, params: { playlist: max_params } }

        it { expect { subject }.to change { Playlist.count }.by(1) }

        it { is_expected.to assign(Playlist.last, :playlist).with_attributes(max_params).and_be_valid }

        it { is_expected.to send_user_to(admin_playlist_path(assigns(:playlist))) }

        it { is_expected.to have_flash(:success, "admin.flash.playlists.success.create") }

        it { subject; expect(Playlist.last.author).to eq(controller.current_user) }
      end

      context "with invalid params" do
        let(:operation) { post :create, params: { playlist: bad_params } }

        subject { operation }

        it { is_expected.to successfully_render("admin/playlists/new") }

        describe "instance" do
          subject { operation; assigns(:playlist) }

          it { is_expected.to have_coerced_attributes(bad_params) }
          it { is_expected.to be_invalid }
        end

        describe "assigns" do
          subject { operation; assigns(:works) }

          it { is_expected.to be_a_kind_of(Array) }
        end
      end
    end

    describe "GET #edit" do
      subject { get :edit, params: { id: instance.to_param } }

      it { is_expected.to successfully_render("admin/playlists/edit") }
      it { is_expected.to assign(instance, :playlist) }
    end

    describe "PUT #update" do
      let(    :update_params) { { title: "New Title" } }
      let(:bad_update_params) { { title: ""          } }

      context "with valid params" do
        subject do
          put :update, params: { id: instance.to_param, playlist: update_params }
        end

        it { is_expected.to assign(instance, :playlist).with_attributes(update_params).and_be_valid }

        it { is_expected.to send_user_to(admin_playlist_path(assigns(:playlist))) }

        it { is_expected.to have_flash(:success, "admin.flash.playlists.success.update") }
      end

      context "with invalid params" do
        let(:operation) do
          put :update, params: { id: instance.to_param, playlist: bad_update_params }
        end

        subject { operation }

        it { is_expected.to successfully_render("admin/playlists/edit") }

        it { is_expected.to assign(instance, :playlist).with_attributes(bad_update_params).and_be_invalid }

        describe "assigns" do
          subject { operation; assigns(:works) }

          it { is_expected.to be_a_kind_of(Array) }
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:instance) { create(:minimal_playlist) }

      subject { delete :destroy, params: { id: instance.to_param } }

      it { expect { subject }.to change(Playlist, :count).by(-1) }

      it { is_expected.to send_user_to(admin_playlists_path) }

      it { is_expected.to have_flash(:success, "admin.flash.playlists.success.destroy") }
    end

    describe "POST #reorder_playlistings" do
      let(:instance) { create(:complete_playlist) }
      let(:shuffled) { instance.playlistings.ids.shuffle }

      describe "non-xhr" do
        subject do
          post :reorder_playlistings, params: { id: instance.to_param, playlisting_ids: shuffled }
        end

        it { is_expected.to render_bad_request }
      end

      describe "xhr" do
        let(:operation) do
          post :reorder_playlistings, xhr: true, params: { id: instance.to_param, playlisting_ids: shuffled }
        end

        subject { operation }

        it { expect(response).to have_http_status(200) }

        describe "reordering" do
          subject { operation; instance.reload.playlistings.ids }

          it { is_expected.to eq(shuffled) }
        end
      end
    end
  end
end
