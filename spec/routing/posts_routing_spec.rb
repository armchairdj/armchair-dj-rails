require "rails_helper"

RSpec.describe PostsController, type: :routing do
  it "#index" do
    expect(get: "/posts").to route_to("posts#index")
  end

  it "#new" do
    expect(get: "/posts/new").to route_to("posts#new")
  end

  it "#show" do
    expect(get: "/posts/1").to route_to("posts#show", :id => "1")
  end

  it "#edit" do
    expect(get: "/posts/1/edit").to route_to("posts#edit", :id => "1")
  end

  it "#create" do
    expect(:post => "/posts").to route_to("posts#create")
  end

  it "#update via PUT" do
    expect(put: "/posts/1").to route_to("posts#update", :id => "1")
  end

  it "#update via PATCH" do
    expect(patch: "/posts/1").to route_to("posts#update", :id => "1")
  end

  it "#destroy" do
    expect(delete: "/posts/1").to route_to("posts#destroy", :id => "1")
  end
end
