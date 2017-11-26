require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe "associations" do
    describe "associations" do
      it { should have_many(:songs) }
      it { should have_many(:albums) }
    end
  end

  describe "scopes" do
    pending "#alphabetical"
  end

  describe "hooks" do

  end

  describe "validations" do
    describe "name" do
      it { should validate_presence_of(:name) }
    end
  end

  describe "instance" do

  end

  describe "class" do

  end
end
