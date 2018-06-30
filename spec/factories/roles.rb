# == Schema Information
#
# Table name: roles
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  name       :string
#  work_type  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_roles_on_alpha      (alpha)
#  index_roles_on_work_type  (work_type)
#

FactoryBot.define do
  factory :role do
    work_type nil
    name      nil
    initialize_with { Role.find_or_initialize_by(work_type: work_type, name: name) }

    ###########################################################################
    # TRAITS.
    ###########################################################################

    trait :with_name do
      name { generate(:role_name) }
    end

    trait :with_work_type do
      work_type "Song"
    end

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_role do
      with_name
      with_work_type
    end

    factory :complete_role, parent: :minimal_role do; end
  end
end
