module Contribution
  extend ActiveSupport::Concern

  included do
    belongs_to :artist, required: true

    validates :role, presence: true

    validates :artist, presence: true

    accepts_nested_attributes_for :artist, allow_destroy: true

    enum role: {
      credited_artist:     0,
      featured_artist:     1,
      songwriter:         10,
      producer:           20,
      executive_producer: 21,
      co_producer:        22,
      engineer:           30,
      musician:          100
    }
  end
end
