module Contributable
  extend ActiveSupport::Concern

  included do
    self.create_relations
  end

  class_methods do
    def create_relations
      relation_sym   = :"#{self.model_name.param_key}_contributions"
      relation_klass = "#{self.model_name}Contribution".constantize
      enum_value     = relation_klass.contributions["credited_artist"]

      has_many relation_sym

      has_many :contributors,
        through: relation_sym, source: :artist, class_name: "Artist"

      has_many :artists, -> { where(relation_sym => { contribution: enum_value }) },
        through: relation_sym
    end
  end

  def postable_dropdown_label
    "#{self.artists.join(" & ").name}: #{self.title}"
  end
end
