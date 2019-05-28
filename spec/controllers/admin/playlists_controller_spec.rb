# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PlaylistsController do
  let(:instance) { create(:minimal_playlist) }

  describe "concerns" do
    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "a_ginsu_index"
    end

    describe "GET #show" do
      subject do
        get :show, params: { id: instance.to_param }
      end

      it { is_expected.to successfully_render("admin/playlists/show") }

      it { is_expected.to assign(instance, :playlist) }
    end

    describe "GET #new" do
      subject { send_request }

      let(:send_request) { get :new }

      it { is_expected.to successfully_render("admin/playlists/new") }

      describe "instance" do
        subject do
          send_request
          assigns(:playlist)
        end

        it { is_expected.to be_a_new(Playlist) }
      end
    end

    describe "POST #create" do
      let(:min_params) { attributes_for(:minimal_playlist).except(:author_id) }
      let(:max_params) { attributes_for(:complete_playlist).except(:author_id) }
      let(:bad_params) { attributes_for(:minimal_playlist).except(:author_id, :title) }

      context "with min valid params" do
        subject { post :create, params: { playlist: min_params } }

        it { expect { subject }.to change(Playlist, :count).by(1) }

        it { is_expected.to assign(Playlist.last, :playlist).with_attributes(min_params).and_be_valid }

        it { is_expected.to send_user_to(admin_playlist_path(assigns(:playlist))) }

        it { is_expected.to have_flash(:success, "admin.flash.playlists.success.create") }

        it "assigns author" do
          subject
          expect(Playlist.last.author).to eq(controller.current_user)
        end
      end

      context "with max valid params" do
        subject { post :create, params: { playlist: max_params } }

        it { expect { subject }.to change(Playlist, :count).by(1) }

        it { is_expected.to assign(Playlist.last, :playlist).with_attributes(max_params).and_be_valid }

        it { is_expected.to send_user_to(admin_playlist_path(assigns(:playlist))) }

        it { is_expected.to have_flash(:success, "admin.flash.playlists.success.create") }

        it "assigns author" do
          subject
          expect(Playlist.last.author).to eq(controller.current_user)
        end
      end

      context "with invalid params" do
        subject { send_request }

        let(:send_request) do
          post :create, params: { playlist: bad_params }
        end

        it { is_expected.to successfully_render("admin/playlists/new") }

        describe "instance" do
          subject do
            send_request
            assigns(:playlist)
          end

          it { is_expected.to have_coerced_attributes(bad_params) }
          it { is_expected.to be_invalid }
        end

        describe "assigns" do
          subject do
            send_request
            assigns(:works)
          end

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
      let(:update_params) { { title: "New Title" } }
      let(:bad_update_params) { { title: "" } }

      context "with valid params" do
        subject do
          put :update, params: { id: instance.to_param, playlist: update_params }
        end

        it { is_expected.to assign(instance, :playlist).with_attributes(update_params).and_be_valid }

        it { is_expected.to send_user_to(admin_playlist_path(assigns(:playlist))) }

        it { is_expected.to have_flash(:success, "admin.flash.playlists.success.update") }
      end

      context "with invalid params" do
        subject { send_request }

        let(:send_request) do
          put :update, params: { id: instance.to_param, playlist: bad_update_params }
        end

        it { is_expected.to successfully_render("admin/playlists/edit") }

        it { is_expected.to assign(instance, :playlist).with_attributes(bad_update_params).and_be_invalid }

        describe "assigns" do
          subject do
            send_request
            assigns(:works)
          end

          it { is_expected.to be_a_kind_of(Array) }
        end
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: { id: instance.to_param } }

      let!(:instance) { create(:minimal_playlist) }

      it { expect { subject }.to change(Playlist, :count).by(-1) }

      it { is_expected.to send_user_to(admin_playlists_path) }

      it { is_expected.to have_flash(:success, "admin.flash.playlists.success.destroy") }
    end

    describe "POST #reorder_tracks" do
      let(:instance) { create(:complete_playlist) }
      let(:shuffled) { instance.tracks.ids.shuffle }

      describe "non-xhr" do
        subject do
          post :reorder_tracks, params: { id: instance.to_param, track_ids: shuffled }
        end

        it { is_expected.to render_bad_request }
      end

      describe "xhr" do
        subject { send_request }

        let(:send_request) do
          post :reorder_tracks, xhr: true, params: { id: instance.to_param, track_ids: shuffled }
        end

        it { expect(response).to have_http_status(200) }

        describe "reordering" do
          subject do
            send_request
            instance.reload.tracks.ids
          end

          it { is_expected.to eq(shuffled) }
        end
      end
    end
  end
end
