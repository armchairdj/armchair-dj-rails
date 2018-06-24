class ComicBook < Work

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

  def self.facets
    [:publisher, :narrative_genre]
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
