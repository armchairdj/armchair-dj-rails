# frozen_string_literal: true
# == Schema Information
#
# Table name: creator_identities
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pseudonym_id :bigint(8)
#  real_name_id :bigint(8)
#
# Indexes
#
#  index_creator_identities_on_pseudonym_id  (pseudonym_id)
#  index_creator_identities_on_real_name_id  (real_name_id)
#
# Foreign Keys
#
#  fk_rails_...  (pseudonym_id => creators.id)
#  fk_rails_...  (real_name_id => creators.id)
#

class Creator::Identity < ApplicationRecord
  self.table_name = "creator_identities"

  #############################################################################
  # CONCERNING: Real name.
  #############################################################################

  belongs_to :real_name, class_name: "Creator", foreign_key: :real_name_id

  concerning :RealNameValidation do
    included do
      validates :real_name, presence: true

      validates :real_name_id, uniqueness: { scope: [:pseudonym_id] }

      validate { real_name_is_primary }
    end

  private

    def real_name_is_primary
      self.errors.add :real_name_id, :not_primary unless real_name.try(:primary?)
    end
  end

  #############################################################################
  # CONCERNING: Pseudonym.
  #############################################################################

  belongs_to :pseudonym, class_name: "Creator", foreign_key: :pseudonym_id

  concerning :PseudonymValidation do
    included do
      validates :pseudonym,  presence: true

      validates :pseudonym_id, uniqueness: true

      validate { pseudonym_is_secondary }
    end

  private

    def pseudonym_is_secondary
      self.errors.add :pseudonym_id, :not_secondary unless pseudonym.try(:secondary?)
    end
  end
end