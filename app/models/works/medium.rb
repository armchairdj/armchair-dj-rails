# frozen_string_literal: true

class Medium < Work
  self.abstract_class = true

  #############################################################################
  # CONCERNING: STI Subclassed.
  #############################################################################

  concerning :Subclassing do
    class_methods do
      def model_name
        Work.model_name
      end

      def true_model_name
        ActiveModel::Name.new(self.name.constantize)
      end

      def display_medium
        I18n.t("activerecord.subclasses.work.#{true_model_name.i18n_key}")
      end
    end

    included do
      delegate :true_model_name, to: :class
      delegate :display_medium,  to: :class
    end
  end

  #############################################################################
  # CONCERNING: Roles.
  #############################################################################

  def available_roles
    Role.for_medium(self.medium).alpha
  end

  def available_role_ids
    available_roles.ids
  end

  #############################################################################
  # Instance: Roles.
  #############################################################################

  def sluggable_parts
    [display_medium.pluralize, display_makers, title, subtitle]
  end
end
