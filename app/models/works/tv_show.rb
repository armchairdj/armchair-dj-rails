# == Schema Information
#
# Table name: works
#
#  id             :bigint(8)        not null, primary key
#  alpha          :string
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#  subtitle       :string
#  title          :string           not null
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_works_on_alpha     (alpha)
#  index_works_on_ancestry  (ancestry)
#  index_works_on_type      (type)
#

class TvShow < Work

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

  #############################################################################
  # SCOPES.
  #############################################################################

  def self.facets
    [:narrative_genre, :tv_network, :hollywood_studio]
  end

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
