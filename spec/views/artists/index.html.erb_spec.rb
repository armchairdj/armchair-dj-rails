require 'rails_helper'

RSpec.describe 'artists/index', type: :view do
  before(:each) do
    assign(:artists, [
      create(:minimal_artist),
      create(:minimal_artist)
    ])
  end

  it "renders a list of artists" do
    render
  end
end
