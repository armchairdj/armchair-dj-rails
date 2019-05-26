# frozen_string_literal: true

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

FactoryBot.define do
  factory :work_relationship, class: "Work::Relationship" do
    factory :minimal_work_relationship do
      association :target, factory: :minimal_song
      connection :member_of
      association :source, factory: :minimal_album
    end
  end
end
