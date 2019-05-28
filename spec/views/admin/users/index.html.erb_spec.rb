# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/users/index" do
  login_root

  before(:each) do
    3.times { create(:minimal_user) }

    @model_class = assign(:model_name, User)
    @collection = assign(:collection, Ginsu::Collection.new(User.all))
    @users = assign(:users, @collection.resolved)
  end

  it "renders a list of users" do
    render
  end
end
