require 'rails_helper'

RSpec.describe 'admin/posts/edit', type: :view do
  before(:each) do
    @model_class = assign(:model_name, Post)
    @post        = assign(:post, create(:minimal_post))
  end

  it "renders the edit post form" do
    render

    assert_select "form[action=?][method=?]", admin_post_path(@post), "post" do
      # TODO
    end
  end
end
