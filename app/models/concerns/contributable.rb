module Contributable
  extend ActiveSupport::Concern

  included do
    self.build_dynamic_associations

    validate do
      validate_credited_artist
    end
  end

  class_methods do
    def build_dynamic_associations
      # album_contributions
      # song_contributions
      param = :"#{self.model_name.param_key}_contributions"
      # AlbumContribution
      # SongContribution
      klass = "#{self.model_name}Contribution".constantize
      # AlbumContribution.roles
      # SongContribution.roles
      role = klass.roles["credited_artist"]

      has_many param
      has_many :contributors, through: param, source: :artist, class_name: "Artist"
      has_many :artists, -> { where(param => { role: role }) }, through: param

      accepts_nested_attributes_for param, allow_destroy: true
    end
  end

  def postable_dropdown_label
    "#{self.artists.join(" & ").name}: #{self.title}"
  end

private

  def validate_credited_artist
    return if contributors.reject(&:marked_for_destruction?).count > 0

    errors.add(:contributors, :missing_item)
  end
end
