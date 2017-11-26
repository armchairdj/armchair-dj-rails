require 'rails_helper'

RSpec.describe Album, type: :model do
  describe "associations" do
    it { should belong_to(:artist) }
    it { should have_many(:posts) }
  end

  describe "scopes" do
    pending "#alphabetical"
    pending "#alphabetical_by_artist"
  end

  describe "hooks" do

  end

  describe "validations" do
    describe "title" do
      it { should validate_presence_of(:title) }
    end
  end

  describe "instance" do
    pending "postable_dropdown_option"
  end

  describe "class" do

  end
end
