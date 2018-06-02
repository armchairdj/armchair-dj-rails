# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PlaylistsController, type: :controller do
  context "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { admin_playlists_path }
    end
  end

  context "as root" do
    login_root

    describe "GET #index" do
      it_behaves_like "an_admin_index"
    end

    describe "GET #show" do
      let(:playlist) { create(:minimal_playlist) }

      it "renders" do
        get :show, params: { id: playlist.to_param }

        is_expected.to successfully_render("admin/playlists/show")

        is_expected.to assign(playlist, :playlist)
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
      let(:max_valid_params) { attributes_for(:complete_playlist) }
      let(:min_valid_params) { attributes_for(:minimal_playlist) }
      let(  :invalid_params) { attributes_for(:minimal_playlist).except(:title) }

      context "with min valid params" do
        it "creates a new Playlist" do
          expect {
            post :create, params: { playlist: min_valid_params }
          }.to change { Playlist.count }.by(1)
        end

        it "creates the right attributes" do
          post :create, params: { playlist: min_valid_params }

          is_expected.to assign(Playlist.last, :playlist).with_attributes(min_valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { playlist: min_valid_params }

          is_expected.to send_user_to(
            admin_playlist_path(assigns(:playlist))
          ).with_flash(:success, "admin.flash.playlists.success.create")
        end
      end

      context "with max valid params" do
        it "creates a new Playlist" do
          expect {
            post :create, params: { playlist: max_valid_params }
          }.to change(Playlist, :count).by(1)
        end

        it "creates the right attributes" do
          post :create, params: { playlist: max_valid_params }

          is_expected.to assign(Playlist.last, :playlist).with_attributes(max_valid_params).and_be_valid
        end

        it "redirects to index" do
          post :create, params: { playlist: max_valid_params }

          is_expected.to send_user_to(
            admin_playlist_path(assigns(:playlist))
          ).with_flash(:success, "admin.flash.playlists.success.create")
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { playlist: invalid_params }

          is_expected.to successfully_render("admin/playlists/new")

          expect(assigns(:playlist)).to have_coerced_attributes(invalid_params)
          expect(assigns(:playlist)).to be_invalid

          expect(assigns(:works)).to be_a_kind_of(Array)
        end
      end
    end

    describe "GET #edit" do
      let(:playlist) { create(:minimal_playlist) }

      it "renders" do
        get :edit, params: { id: playlist.to_param }

        is_expected.to successfully_render("admin/playlists/edit")
        is_expected.to assign(playlist, :playlist)
      end
    end

    describe "PUT #update" do
      let(:playlist) { create(:minimal_playlist) }

      let(:min_valid_params) { { title: "New Title" } }
      let(  :invalid_params) { { title: ""         } }

      context "with valid params" do
        it "updates the requested playlist" do
          put :update, params: { id: playlist.to_param, playlist: min_valid_params }

          is_expected.to assign(playlist, :playlist).with_attributes(min_valid_params).and_be_valid
        end

        it "redirects to index" do
          put :update, params: { id: playlist.to_param, playlist: min_valid_params }

          is_expected.to send_user_to(
            admin_playlist_path(assigns(:playlist))
          ).with_flash(:success, "admin.flash.playlists.success.update")
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: playlist.to_param, playlist: invalid_params }

          is_expected.to successfully_render("admin/playlists/edit")

          is_expected.to assign(playlist, :playlist).with_attributes(invalid_params).and_be_invalid

          expect(assigns(:works)).to be_a_kind_of(Array)
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:playlist) { create(:minimal_playlist) }

      it "destroys the requested playlist" do
        expect {
          delete :destroy, params: { id: playlist.to_param }
        }.to change(Playlist, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: playlist.to_param }

        is_expected.to send_user_to(admin_playlists_path).with_flash(
          :success, "admin.flash.playlists.success.destroy"
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
          "Visible",
          "Hidden",
        ])
      end
    end

    describe "#allowed_sorts" do
      subject { described_class.new.send(:allowed_sorts) }

      specify "keys are short sort names" do
        expect(subject.keys).to match_array([
          "Default",
          "Title",
          "Author",
          "PPC",
          "DPC",
        ])
      end
    end
  end
end
