module Contribution
  extend ActiveSupport::Concern

  included do
    belongs_to :creator, required: true

    validates :role, presence: true

    validates :creator, presence: true

    accepts_nested_attributes_for :creator, allow_destroy: true

    enum role: {
      credited_creator:     0,
      featured_creator:     1,
      workwriter:         10,
      producer:           20,
      executive_producer: 21,
      co_producer:        22,
      engineer:           30,
      musician:          100
    }
  end
end
