require 'rails_helper'

RSpec.describe "Creators", type: :request do
  describe "GET /creators" do
    it "works! (now write some real specs)" do
      get creators_path
      expect(response).to be_success
    end
  end
end
