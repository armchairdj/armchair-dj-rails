# frozen_string_literal: true

RSpec.shared_examples "an_errorable_controller" do
  describe "protected" do
    before(:each) do
      allow(Rails.logger).to receive(:error)
    end

    let(:json_headers) { {"HTTP_ACCEPT" => "application/json"} }

    describe "#handle_403_recoverable" do
      before(:each) do
        allow(controller).to receive(:set_user_return_to)
      end

      controller do
        def index
          raise Pundit::NotAuthenticatedError.new "error"
        end
      end

      describe "behavior" do
        describe "html" do
          it "sets session variable" do
            expect(controller).to receive(:set_user_return_to)

            get :index
          end

          it "redirects to login" do
            get :index

            expect(response).to redirect_to(new_user_session_path)
          end
        end

        describe "xhr" do
          it "does not set session variable" do
            expect(controller).to_not receive(:set_user_return_to)

            get :index, { xhr: true }
          end

          it "renders json" do
            get :index, { xhr: true }

            expect(response     ).to have_http_status(403)
            expect(response.body).to eq("{}")
          end
        end

        describe "json" do
          before(:each) do
            request.headers.merge! json_headers
          end

          it "does not session variable" do
            expect(controller).to_not receive(:set_user_return_to)

            get :index
          end

          it "renders json" do
            get :index

            expect(response     ).to have_http_status(403)
            expect(response.body).to eq("{}")
          end
        end
      end

      describe "rescue_from" do
        before(:each) do
          allow(controller).to receive(:handle_403_recoverable)
          expect(controller).to receive(:handle_403_recoverable)
        end

        describe "Pundit::NotAuthenticatedError" do
          it "handles error" do
            get :index
          end
        end
      end
    end

    describe "#handle_403" do
      controller do
        def index
          raise Pundit::NotAuthorizedError.new "error"
        end
      end

      describe "behavior" do
        before(:each) do
          expect(Rails.logger).to receive(:error)
        end

        describe "html" do
          it "renders error page" do
            get :index

            expect(response).to render_template("errors/permission_denied")
          end
        end

        describe "xhr" do
          it "renders json" do
            get :index, { xhr: true }

            expect(response     ).to have_http_status(403)
            expect(response.body).to eq("{}")
          end
        end

        describe "json" do
          before(:each) do
            request.headers.merge! json_headers
          end

          it "renders json" do
            get :index

            expect(response     ).to have_http_status(403)
            expect(response.body).to eq("{}")
          end
        end
      end

      describe "rescue_from" do
        before(:each) do
          allow(controller).to receive(:handle_403)
          expect(controller).to receive(:handle_403)
        end

        describe "Pundit::NotAuthorizedError" do
          it "handles error" do
            get :index
          end
        end
      end
    end

    describe "#handle_404" do
      controller do
        def index
          raise ActiveRecord::RecordNotFound.new "error"
        end
      end

      describe "behavior" do
        before(:each) do
          expect(Rails.logger).to receive(:error)
        end

        describe "html" do
          it "renders error page" do
            get :index

            expect(response).to render_template("errors/not_found")
          end
        end

        describe "xhr" do
          it "renders json" do
            get :index, { xhr: true }

            expect(response     ).to have_http_status(404)
            expect(response.body).to eq("{}")
          end
        end

        describe "json" do
          before(:each) do
            request.headers.merge! json_headers
          end

          it "renders json" do
            get :index

            expect(response     ).to have_http_status(404)
            expect(response.body).to eq("{}")
          end
        end
      end

      describe "rescue_from" do
        before(:each) do
          allow(controller).to receive(:handle_404)
          expect(controller).to receive(:handle_404)
        end

        describe "ActiveRecord::RecordNotFound" do
          it "handles error" do
            get :index
          end
        end

        describe "ActionController::RoutingError" do
          controller do
            def index
              raise ActionController::RoutingError.new "error"
            end
          end

          it "handles error" do
            get :index
          end
        end

        # describe "ActionController::UnknownController" do
        #   controller do
        #     def index
        #       raise ActionController::UnknownController.new "error"
        #     end
        #   end
        #
        #   it "handles error" do
        #     get :index
        #   end
        # end

        describe "AbstractController::ActionNotFound" do
          controller do
            def index
              raise AbstractController::ActionNotFound.new "error"
            end
          end

          it "handles error" do
            get :index
          end
        end
      end
    end

    describe "#handle_422" do
      controller do
        def index
          raise ActionController::UnknownFormat.new "error"
        end
      end

      describe "behavior" do
        before(:each) do
          expect(Rails.logger).to receive(:error)
        end

        describe "html" do
          it "renders error page" do
            get :index

            expect(response).to render_template("errors/bad_request")
          end
        end

        describe "xhr" do
          it "renders json" do
            get :index, { xhr: true }

            expect(response     ).to have_http_status(422)
            expect(response.body).to eq("{}")
          end
        end

        describe "json" do
          before(:each) do
            request.headers.merge! json_headers
          end

          it "renders json" do
            get :index

            expect(response     ).to have_http_status(422)
            expect(response.body).to eq("{}")
          end
        end
      end

      describe "rescue_from" do
        before(:each) do
          allow(controller).to receive(:handle_422)
          expect(controller).to receive(:handle_422)
        end

        describe "ActionController::UnknownFormat" do
          it "handles error" do
            get :index
          end
        end
      end
    end

    describe "#handle_500" do
      controller do
        rescue_from StandardError, with: :handle_500

        def index
          raise StandardError
        end
      end

      describe "behavior" do
        before(:each) do
          expect(Rails.logger).to receive(:error)
        end

        describe "html" do
          it "renders error page" do
            get :index

            expect(response).to render_template("errors/internal_server_error")
          end
        end

        describe "xhr" do
          it "renders json" do
            get :index, { xhr: true }

            expect(response     ).to have_http_status(500)
            expect(response.body).to eq("{}")
          end
        end

        describe "json" do
          before(:each) do
            request.headers.merge! json_headers
          end

          it "renders json" do
            get :index

            expect(response     ).to have_http_status(500)
            expect(response.body).to eq("{}")
          end
        end
      end

      describe "rescue_from" do
        before(:each) do
          allow(controller).to  receive(:handle_500)
          expect(controller).to receive(:handle_500)
        end

        describe "StandardError" do
          it "handles error" do
            get :index
          end
        end
      end
    end
  end

  describe "private" do
    describe "#set_user_return_to" do
      it "sets session variable on get" do
        allow(request).to receive(:url).and_return("remembered")
        allow(request).to receive(:xhr?).and_return(false)
        allow(request).to receive(:get?).and_return(true)

        controller.send(:set_user_return_to)

        expect(session["user_return_to"]).to eq("remembered")
      end

      it "does not set session variable on xhr" do
        allow(request).to receive(:xhr?).and_return(true)
        allow(request).to receive(:get?).and_return(true)

        expect(session["user_return_to"]).to eq(nil)
      end

      it "does not set session variable on non-get" do
        allow(request).to receive(:xhr?).and_return(false)
        allow(request).to receive(:get?).and_return(false)

        expect(session["user_return_to"]).to eq(nil)
      end
    end
  end
end
