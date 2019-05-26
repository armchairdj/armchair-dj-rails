# frozen_string_literal: true

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

RSpec.describe Link do
  describe "concerns" do
    it_behaves_like "an_application_record"

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:linkable) }
  end

  describe "validations" do
    subject { build_minimal_instance }

    it { is_expected.to validate_presence_of(:url) }

    it { is_expected.to validate_urlness_of(:url) }

    it { is_expected.to validate_presence_of(:description) }
  end
end
