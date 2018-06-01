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
      context "without records" do
        context "All scope (default)" do
          it "renders" do
            get :index

            is_expected.to successfully_render("admin/playlists/index")

            expect(assigns(:playlists)).to paginate(0).of_total_records(0)
          end
        end

        context "Visible scope" do
          it "renders" do
            get :index, params: { scope: "Visible" }

            is_expected.to successfully_render("admin/playlists/index")

            expect(assigns(:playlists)).to paginate(0).of_total_records(0)
          end
        end

        context "Hidden scope" do
          it "renders" do
            get :index, params: { scope: "Hidden" }

            is_expected.to successfully_render("admin/playlists/index")

            expect(assigns(:playlists)).to paginate(0).of_total_records(0)
          end
        end
      end

      context "with records" do
        context "All scope (default)" do
          before(:each) do
            21.times { create(:minimal_playlist) }
          end

          it "renders" do
            get :index

            is_expected.to successfully_render("admin/playlists/index")

            expect(assigns(:playlists)).to paginate(20).of_total_records(21)
          end

          it "renders second page" do
            get :index, params: { page: "2" }

            is_expected.to successfully_render("admin/playlists/index")

            expect(assigns(:playlists)).to paginate(1).of_total_records(21)
          end
        end

        pending "Visible scope"
        pending "Hidden scope"
      end

      context "sorts" do
        pending "Title"
        pending "VPC"
        pending "NVPC"
      end
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

          ap assigns(:playlist).valid?
          ap assigns(:playlist).errors

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
        expect(subject.keys).to eq([
          "All",
          "Visible",
          "Hidden",
        ])
      end
    end

    pending "allowed_sorts"
  end
end
