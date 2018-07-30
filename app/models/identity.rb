# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pseudonym_id :bigint(8)
#  real_name_id :bigint(8)
#
# Indexes
#
#  index_identities_on_pseudonym_id  (pseudonym_id)
#  index_identities_on_real_name_id  (real_name_id)
#
# Foreign Keys
#
#  fk_rails_...  (pseudonym_id => creators.id)
#  fk_rails_...  (real_name_id => creators.id)
#


class Identity < ApplicationRecord

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :real_name, class_name: "Creator", foreign_key: :real_name_id
  belongs_to :pseudonym, class_name: "Creator", foreign_key: :pseudonym_id

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :real_name,  presence: true
  validates :pseudonym,  presence: true

  validates :real_name_id, uniqueness: { scope: [:pseudonym_id] }
  validates :pseudonym_id, uniqueness: true

  validate { real_name_is_primary }
  validate { pseudonym_is_secondary }

  #############################################################################
  # INSTANCE.
  #############################################################################

private

  def real_name_is_primary
    self.errors.add :real_name_id, :not_primary unless real_name.try(:primary?)
  end

  def pseudonym_is_secondary
    self.errors.add :pseudonym_id, :not_secondary unless pseudonym.try(:secondary?)
  end
end
