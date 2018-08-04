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

FactoryBot.define do
  factory :work_versioning, class: 'Work::Versioning' do
    
  end
end
