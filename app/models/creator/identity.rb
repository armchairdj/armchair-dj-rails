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

class Creator
  class Identity < ApplicationRecord
    self.table_name = "creator_identities"

    concerning :RealNameAssociation do
      included do
        belongs_to :real_name, class_name: "Creator", foreign_key: :real_name_id

        validates :real_name, presence: true

        validates :real_name_id, uniqueness: { scope: [:pseudonym_id] }

        validate { real_name_is_primary }
      end

      private

      def real_name_is_primary
        errors.add :real_name_id, :not_primary unless real_name&.primary?
      end
    end

    concerning :PseudonymAssociation do
      included do
        belongs_to :pseudonym, class_name: "Creator", foreign_key: :pseudonym_id

        validates :pseudonym,  presence: true

        validates :pseudonym_id, uniqueness: true

        validate { pseudonym_is_secondary }
      end

      private # rubocop:disable Lint/UselessAccessModifier

      def pseudonym_is_secondary
        errors.add :pseudonym_id, :not_secondary unless pseudonym&.secondary?
      end
    end
  end
end
