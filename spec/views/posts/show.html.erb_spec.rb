require "rails_helper"

RSpec.describe "posts/show", type: :view do
  before(:each) do
    @post = assign(:post, Post.create!())
  end

  it "renders" do
    render
  end
end
