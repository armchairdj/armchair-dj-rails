require 'rails_helper'

RSpec.describe 'works/show', type: :view do
  before(:each) do
    @work = assign(:work, Work.create!())
  end

  it "renders" do
    render
  end
end
