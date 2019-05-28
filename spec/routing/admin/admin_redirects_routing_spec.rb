# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin route redirection", type: :request do
  it "redirects /admin" do
    get "/admin"

    is_expected.to send_user_to(admin_reviews_path)
  end
end
