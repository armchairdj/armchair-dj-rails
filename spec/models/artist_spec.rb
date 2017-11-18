require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe "validation of" do
    describe "name" do
      it { should validate_presence_of(:name) }
    end
  end
end
