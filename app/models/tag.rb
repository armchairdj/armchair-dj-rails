# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_alpha  (alpha)
#

class Tag < ApplicationRecord
  concerning :Alphabetization do
    included do
      include Alphabetizable
    end

    def alpha_parts
      [name]
    end
  end

  concerning :GinsuIntegration do
    included do
      scope :for_list, -> {}
      scope :for_show, -> { includes(:posts) }
    end
  end

  concerning :NameAttribute do
    included do
      validates :name, presence: true
    end
  end

  concerning :PostAssociations do
    included do
      has_and_belongs_to_many :posts, -> { distinct }
    end
  end
end
