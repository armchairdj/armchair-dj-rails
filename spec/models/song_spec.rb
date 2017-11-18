require 'rails_helper'

RSpec.describe Song, type: :model do
  describe "associations" do
    it { should belong_to(:artist) }
  end

  describe "validation of" do
    describe "title" do
      it { should validate_presence_of(:title) }
    end
  end
end
