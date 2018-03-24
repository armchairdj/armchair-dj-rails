module Contribution
  extend ActiveSupport::Concern

  included do
    enum contribution: {
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
