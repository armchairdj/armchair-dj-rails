require "rails_helper"

RSpec.describe UsersController, type: :routing do
  it "#index" do
    expect(get: "/users").to route_to("users#index")
  end

  it "#new" do
    expect(get: "/users/new").to route_to("users#new")
  end

  it "#show" do
    expect(get: "/users/1").to route_to("users#show", :id => "1")
  end

  it "#edit" do
    expect(get: "/users/1/edit").to route_to("users#edit", :id => "1")
  end

  it "#create" do
    expect(:post => "/users").to route_to("users#create")
  end

  it "#update via PUT" do
    expect(put: "/users/1").to route_to("users#update", :id => "1")
  end

  it "#update via PATCH" do
    expect(patch: "/users/1").to route_to("users#update", :id => "1")
  end

  it "#destroy" do
    expect(delete: "/users/1").to route_to("users#destroy", :id => "1")
  end
end
