module Contribution
  extend ActiveSupport::Concern

  included do
    self.build_dynamic_associations

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

  class_methods do
    def build_dynamic_associations
      inverse = self.model_name.param_key

      puts ">>"
      puts inverse
      puts "<<"

      belongs_to :artist, required: true, inverse_of: inverse
    end
  end
end
