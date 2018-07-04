# == Schema Information
#
# Table name: links
#
#  id            :bigint(8)        not null, primary key
#  description   :string
#  linkable_type :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  linkable_id   :bigint(8)
#
# Indexes
#
#  index_links_on_linkable_type_and_linkable_id  (linkable_type,linkable_id)
#

require "rails_helper"

RSpec.describe Link, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:linkable) }
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:url) }

    it { is_expected.to validate_urlness_of(:url) }

    it { is_expected.to validate_presence_of(:description) }
  end
end
