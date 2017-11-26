require 'rails_helper'

RSpec.describe "posts/show", type: :view do
  before(:each) do
    @post = assign(:post, create(:minimal_post))
  end

  it "renders attributes in <p>" do
    render
  end
end
