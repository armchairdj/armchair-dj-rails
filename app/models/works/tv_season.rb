class TvSeason < Work

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Workable

  #############################################################################
  # CLASS.
  #############################################################################

  def self.characteristics
    [:narrative_genre, :tv_network, :hollywood_studio]
  end

  def self.available_parent_types
    [TvShow]
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

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
