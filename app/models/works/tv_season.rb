class TvSeason < Work

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

  def self.characteristics
    [:narrative_genre, :tv_network, :hollywood_studio]
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  tv_season_facets = [
    FactoryBot.create(:facet, medium: tv_season, category: narrative_genre),
    FactoryBot.create(:facet, medium: tv_season, category: hollywood_studio),
    FactoryBot.create(:facet, medium: tv_season, category: tv_network),
  ]

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

end
