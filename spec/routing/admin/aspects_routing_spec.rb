require "rails_helper"

RSpec.describe Admin::TagsController do
  it "#index" do
    expect(get: "/admin/aspects").to route_to("admin/aspects#index")
  end

  it "#new" do
    expect(get: "/admin/aspects/new").to route_to("admin/aspects#new")
  end

  it "#show" do
    expect(get: "/admin/aspects/1").to route_to("admin/aspects#show", :id => "1")
  end

  it "#edit" do
    expect(get: "/admin/aspects/1/edit").to route_to("admin/aspects#edit", :id => "1")
  end

  it "#create" do
    expect(:post => "/admin/aspects").to route_to("admin/aspects#create")
  end

  it "#update via PUT" do
    expect(put: "/admin/aspects/1").to route_to("admin/aspects#update", :id => "1")
  end

  it "#update via PATCH" do
    expect(patch: "/admin/aspects/1").to route_to("admin/aspects#update", :id => "1")
  end

  it "#destroy" do
    expect(delete: "/admin/aspects/1").to route_to("admin/aspects#destroy", :id => "1")
  end
end
