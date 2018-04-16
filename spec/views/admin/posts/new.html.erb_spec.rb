require 'rails_helper'

RSpec.describe 'admin/posts/new', type: :view do
  before(:each) do
    @model_class = assign(:model_name, Post)
    @post        = assign(:post, Post.new())
  end

  it "renders new post form" do
    render

    assert_select "form[action=?][method=?]", admin_posts_path, "post" do
      # TODO
    end
  end
end
