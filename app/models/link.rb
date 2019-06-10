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

class Link < ApplicationRecord
  concerning :DescriptionAttribute do
    included do
      validates :description, presence: true
    end
  end

  concerning :LinkableAssociation do
    included do
      belongs_to :linkable, polymorphic: true
    end
  end

  concerning :UrlAttribute do
    included do
      validates :url, urlness: true
      validates :url, presence: true
    end
  end
end
