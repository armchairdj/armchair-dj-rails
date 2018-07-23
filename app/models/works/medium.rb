# frozen_string_literal: true

class Medium < Work
  self.abstract_class = true

  #############################################################################
  # CLASS ATTRIBUTES.
  #############################################################################

  class_attribute :available_facets, default: []

  #############################################################################
  # CLASS.
  #############################################################################

  def self.model_name
    Work.model_name
  end

  def self.true_model_name
    ActiveModel::Name.new(self.name.constantize)
  end

  def self.display_medium
    I18n.t("activerecord.subclasses.work.#{true_model_name.i18n_key}")
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validate { only_available_facets }

  def only_available_facets
    candidates = aspects.reject(&:marked_for_destruction?)
    disallowed = candidates.reject { |x| available_facets.include?(x.facet.to_sym) }

    self.errors.add(:aspects, :invalid) if disallowed.any?
  end

  private :only_available_facets

  #############################################################################
  # INSTANCE.
  #############################################################################

  def true_model_name
    self.class.true_model_name
  end

  def display_medium
    self.class.display_medium
  end

  def available_roles
    Role.for_medium(self.medium).alpha
  end

  def available_role_ids
    available_roles.ids
  end
end
