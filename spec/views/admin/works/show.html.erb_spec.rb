require 'rails_helper'

RSpec.describe 'admin/works/show', type: :view do
  before(:each) do
    @work = assign(:work, create(:minimal_work))
  end

  it "renders" do
    render
  end
end
