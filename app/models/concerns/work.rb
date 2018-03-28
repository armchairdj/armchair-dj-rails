module Work
  extend ActiveSupport::Concern

  included do
    self.build_dynamic_associations
  end

  class_methods do
    def build_dynamic_associations
      # album_contributions
      #  song_contributions
      param = :"#{self.model_name.param_key}_contributions"
      # AlbumContribution
      #  SongContribution
      klass = "#{self.model_name}Contribution".constantize
      # AlbumContribution.roles
      #  SongContribution.roles
      role = klass.roles["credited_artist"]

      has_many param, inverse_of: self.model_name.param_key
      has_many :contributors, through: param, source: :artist, class_name: "Artist"
      has_many :artists, -> { where(param => { role: role }) }, through: param

      accepts_nested_attributes_for param,
        allow_destroy: true,
        reject_if:     :reject_blank_contributions

      validate do
        validate_contributions(param)
      end

      scope :alphabetical, -> { order(:title) }
    end

    def max_contributions
      10
    end

    def alphabetical_with_artist
      self.all.to_a.sort_by { |c| c.display_name_with_artist }
    end
  end

  def display_name_with_artist
    "#{self.display_artist}: #{self.title}"
  end

  def display_artist
    self.artists.map(&:name).join(" & ")
  end

private

  def reject_blank_contributions(attributes)
    # album_contributions_atrributes
    #  song_contributions_atrributes
    attributes["artist_id"].blank?
  end

  def validate_contributions(param)
    return if self.send(param).reject(&:marked_for_destruction?).count > 0

    self.errors.add(param, :missing)
  end
end
