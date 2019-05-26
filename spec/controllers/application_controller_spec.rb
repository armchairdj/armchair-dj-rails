# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController do
  class PostsController < ApplicationController; end
  class FoosController < ApplicationController; end

  describe "concerns" do
    it_behaves_like "an_errorable_controller"
  end

  describe "Pundit integration" do
    it "includes pundit" do
      expect(described_class.ancestors).to include(Pundit)
    end

    describe "#authorize_model" do
      let(:fake) { PostsController.new }

      before(:each) do
        fake.send(:determine_model_class)
      end

      it "calls Pundit#authorize on the model" do
        expect(fake).to receive(:authorize).with(Post)

        fake.send(:authorize_model)
      end
    end
  end

  describe "Devise integration" do
    describe "#after_sign_in_path_for" do
      let(:member) { build_stubbed(:member) }
      let(:writer) { build_stubbed(:writer) }

      subject { controller.send(:after_sign_in_path_for, user) }

      context "with member" do
        let(:user) { member }

        it { is_expected.to eq(posts_path) }
      end

      context "with writer" do
        let(:user) { writer }

        it { is_expected.to eq(admin_reviews_path) }
      end

      context "with session variable" do
        let(:user) { writer }

        before(:each) do
          expect(controller).to receive(:session).and_return("user_return_to" => "articles/foo_bar_bat")
        end

        it { is_expected.to eq("articles/foo_bar_bat") }
      end
    end

    describe "#after_sign_out_path_for" do
      subject { controller.send(:after_sign_in_path_for, User.new) }

      it { is_expected.to eq(posts_path) }
    end
  end

  describe "included" do
    describe "add_flash_types" do
      describe "error" do
        controller do
          def index
            redirect_to "/", error: "error"
          end
        end

        it "is available" do
          get :index

          expect(controller).to set_flash[:error].to("error")
        end
      end

      describe "success" do
        controller do
          def index
            redirect_to "/", success: "success"
          end
        end

        it "is available" do
          get :index

          expect(controller).to set_flash[:success].to("success")
        end
      end

      describe "info" do
        controller do
          def index
            redirect_to "/", info: "info"
          end
        end

        it "is available" do
          get :index

          expect(controller).to set_flash[:info].to("info")
        end
      end
    end
  end

  describe "instance" do
    describe "private" do
      describe "#determine_model_class" do
        context "sets an instance variable" do
          describe "for model-backed controllers" do
            subject { PostsController.new.send(:determine_model_class) }

            it { is_expected.to eq(Post) }
          end

          describe "for non-model-backed controllers" do
            subject { FoosController.new.send(:determine_model_class) }

            it { is_expected.to eq(nil) }
          end
        end

        describe "before_action" do
          controller do
            def index
              render json: {}, status: :ok
            end
          end

          it "is called automatically" do
            expect(controller).to receive(:determine_model_class)

            get :index
          end
        end
      end

      describe "#determine_layout" do
        subject { controller.send(:determine_layout) }

        it "sets the default layout" do
          is_expected.to eq("public")
        end
      end
    end
  end
end
