require 'rails_helper'

RSpec.describe 'works/show', type: :view do
  before(:each) do
    @work = assign(:work, create(:minimal_work))
  end

  it "renders attributes in <p>" do
    render
  end
end
