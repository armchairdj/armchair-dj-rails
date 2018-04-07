require 'rails_helper'

RSpec.describe 'works/index', type: :view do
  before(:each) do
    21.times do
      create(:minimal_work)
    end

    @scope = assign(:scope, :all)
    @page  = assign(:page, 1)
    @works = assign(:works, Work.all.alphabetical.page(1))
  end

  it "renders a list of works" do
    render
  end
end
