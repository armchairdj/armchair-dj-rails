module Work
  extend ActiveSupport::Concern

  included do
    self.build_dynamic_associations
  end

  class_methods do
    def build_dynamic_associations
      # work_contributions
      #  work_contributions
      param = :"#{self.model_name.param_key}_contributions"
      # WorkContribution
      #  WorkContribution
      klass = "#{self.model_name}Contribution".constantize
      # WorkContribution.roles
      #  WorkContribution.roles
      role = klass.roles["credited_creator"]

      has_many param, inverse_of: self.model_name.param_key
      has_many :contributors, through: param, source: :creator, class_name: "Creator"
      has_many :creators, -> { where(param => { role: role }) }, through: param

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

    def alphabetical_with_creator
      self.all.to_a.sort_by { |c| c.display_name_with_creator }
    end
  end

  def display_name_with_creator
    "#{self.display_creator}: #{self.title}"
  end

  def display_creator
    self.creators.map(&:name).join(" & ")
  end

private

  def reject_blank_contributions(attributes)
    # work_contributions_atrributes
    #  work_contributions_atrributes
    attributes["creator_id"].blank?
  end

  def validate_contributions(param)
    return if self.send(param).reject(&:marked_for_destruction?).count > 0

    self.errors.add(param, :missing)
  end
end
