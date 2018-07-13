# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PlaylistsController, type: :controller do
  let(:instance) { create(:minimal_playlist) }

  describe "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "a_paginatable_controller"
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      it "renders" do
        get :show, params: { id: instance.to_param }

        is_expected.to successfully_render("admin/playlists/show")

        is_expected.to assign(instance, :playlist)
      end
    end

    describe "GET #new" do
      it "renders" do
        get :new

        is_expected.to successfully_render("admin/playlists/new")

        expect(assigns(:playlist)).to be_a_new(Playlist)
      end
    end

    describe "POST #create" do
      let(:min_params) { attributes_for(:minimal_playlist ).except(:author_id) }
      let(:max_params) { attributes_for(:complete_playlist).except(:author_id) }
      let(:bad_params) { attributes_for(:minimal_playlist ).except(:author_id, :title) }

      context "with min valid params" do
        it "creates a new Playlist" do
          expect {
            post :create, params: { playlist: min_params }
          }.to change { Playlist.count }.by(1)
        end

        it "creates the right attributes" do
          post :create, params: { playlist: min_params }

          is_expected.to assign(Playlist.last, :playlist).with_attributes(min_params).and_be_valid
        end

        it "playlist belongs to current_user" do
          post :create, params: { playlist: min_params }

          expect(Playlist.last.author).to eq(controller.current_user)
        end

        it "redirects to index" do
          post :create, params: { playlist: min_params }

          is_expected.to send_user_to(
            admin_playlist_path(assigns(:playlist))
          ).with_flash(:success, "admin.flash.playlists.success.create")
        end
      end

      context "with max valid params" do
        it "creates a new Playlist" do
          expect {
            post :create, params: { playlist: max_params }
          }.to change(Playlist, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { playlist: max_params }

          is_expected.to assign(Playlist.last, :playlist).with_attributes(max_params).and_be_valid
        end

        it "playlist belongs to current_user" do
          post :create, params: { playlist: max_params }

          expect(Playlist.last.author).to eq(controller.current_user)
        end

        it "redirects to index" do
          post :create, params: { playlist: max_params }

          is_expected.to send_user_to(
            admin_playlist_path(assigns(:playlist))
          ).with_flash(:success, "admin.flash.playlists.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { playlist: bad_params }

          is_expected.to successfully_render("admin/playlists/new")

          expect(assigns(:playlist)).to have_coerced_attributes(bad_params)
          expect(assigns(:playlist)).to be_invalid

          expect(assigns(:works)).to be_a_kind_of(Array)
        end
      end
    end

    describe "GET #edit" do
      it "renders" do
        get :edit, params: { id: instance.to_param }

        is_expected.to successfully_render("admin/playlists/edit")
        is_expected.to assign(instance, :playlist)
      end
    end

    describe "PUT #update" do
      let(:update_params) { { title: "New Title" } }
      let(:bad_update_params) { { title: ""         } }

      context "with valid params" do
        it "updates the requested playlist" do
          put :update, params: { id: instance.to_param, playlist: update_params }

          is_expected.to assign(instance, :playlist).with_attributes(update_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: instance.to_param, playlist: update_params }

          is_expected.to send_user_to(
            admin_playlist_path(assigns(:playlist))
          ).with_flash(:success, "admin.flash.playlists.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: instance.to_param, playlist: bad_update_params }

          is_expected.to successfully_render("admin/playlists/edit")

          is_expected.to assign(instance, :playlist).with_attributes(bad_update_params).and_be_invalid

          expect(assigns(:works)).to be_a_kind_of(Array)
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:instance) { create(:minimal_playlist) }

      it "destroys the requested playlist" do
        expect {
          delete :destroy, params: { id: instance.to_param }
        }.to change(Playlist, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: instance.to_param }

        is_expected.to send_user_to(admin_playlists_path).with_flash(
          :success, "admin.flash.playlists.success.destroy"
        )
      end
    end

    describe "POST #reorder_playlistings" do
      let(:instance) { create(:complete_playlist) }
      let(:shuffled) { instance.playlistings.ids.shuffle }

      describe "non-xhr" do
        it "errors" do
          post :reorder_playlistings, params: {
            id: instance.to_param, playlisting_ids: shuffled
          }

          is_expected.to render_bad_request
        end
      end

      describe "xhr" do
        it "reorders playlistings" do
          post :reorder_playlistings, xhr: true, params: {
            id: instance.to_param, playlisting_ids: shuffled
          }

          expect(response).to have_http_status(200)

          expect(instance.reload.playlistings.ids).to eq(shuffled)
        end
      end
    end
  end

  describe "helpers" do
    describe "#allowed_scopes" do
      subject { described_class.new.send(:allowed_scopes) }

      specify "keys are short tab names" do
        expect(subject.keys).to match_array([
          "All",
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
        ])
      end
    end
  end
end
