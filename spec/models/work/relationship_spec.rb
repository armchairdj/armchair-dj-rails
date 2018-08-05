# == Schema Information
#
# Table name: work_relationships
#
#  id         :bigint(8)        not null, primary key
#  connection :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  source_id  :bigint(8)        not null
#  target_id  :bigint(8)        not null
#
# Indexes
#
#  index_work_relationships_on_source_id  (source_id)
#  index_work_relationships_on_target_id  (target_id)
#
# Foreign Keys
#
#  fk_rails_...  (source_id => works.id)
#  fk_rails_...  (target_id => works.id)
#

require "rails_helper"

RSpec.describe Work::Relationship, type: :model do
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
