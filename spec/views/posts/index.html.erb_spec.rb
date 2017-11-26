require 'rails_helper'

RSpec.describe "posts/index", type: :view do
  before(:each) do
    assign(:posts, [
      create(:minimal_post),
      create(:minimal_post)
    ])
  end

  it "renders a list of posts" do
    render
  end
end
