require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "associations" do
    it { should belong_to(:postable) }
  end

  describe "scopes" do
    pending "#reverse_cron"
  end

  describe "hooks" do

  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  describe "instance" do
    pending "#postable_gid"
    pending "#postable_gid="
  end

  describe "class" do

  end
end
