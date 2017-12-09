require 'rails_helper'

RSpec.describe 'artists/edit', type: :view do
  before(:each) do
    @artist = assign(:artist, create(:minimal_artist))
  end

  it "renders the edit artist form" do
    render

    assert_select "form[action=?][method=?]", artist_path(@artist), "post" do
      # TODO
    end
  end
end
