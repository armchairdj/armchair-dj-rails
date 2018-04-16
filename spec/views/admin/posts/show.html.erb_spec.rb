require "rails_helper"

RSpec.describe 'admin/posts/show', type: :view do
  before(:each) do
    @model_class = assign(:model_name, Post)
    @post        = assign(:post, create(:minimal_post))
  end

  it "renders" do
    render
  end
end
