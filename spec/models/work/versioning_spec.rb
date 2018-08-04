# == Schema Information
#
# Table name: work_versionings
#
#  id          :bigint(8)        not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  original_id :bigint(8)
#  revision_id :bigint(8)
#
# Indexes
#
#  index_work_versionings_on_original_id  (original_id)
#  index_work_versionings_on_revision_id  (revision_id)
#
# Foreign Keys
#
#  fk_rails_...  (original_id => works.id)
#  fk_rails_...  (revision_id => works.id)
#

require "rails_helper"

RSpec.describe Work::Versioning, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "concerns" do
    # Nothing so far.
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    # Nothing so far.
  end

  describe "associations" do
    # Nothing so far.
  end

  describe "attributes" do
    describe "nested" do
      # Nothing so far.
    end

    describe "enums" do
      # Nothing so far.
    end
  end

  describe "validations" do
    # Nothing so far.

    describe "conditional" do
      # Nothing so far.
    end

    describe "custom" do
      # Nothing so far.
    end
  end

  describe "hooks" do
    # Nothing so far.

    describe "callbacks" do
      # Nothing so far.
    end
  end

  describe "instance" do
    # Nothing so far.

    describe "private" do
      # Nothing so far.
    end
  end
end
