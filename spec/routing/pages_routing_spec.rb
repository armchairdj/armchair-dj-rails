require "rails_helper"

RSpec.describe PagesController, type: :routing do
  describe 'routing' do

    it "routes to #homepage" do
      expect(:get => "/").to route_to("pages#homepage")
    end
  end
end
