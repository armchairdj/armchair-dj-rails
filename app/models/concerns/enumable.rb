module Enumable
  extend ActiveSupport::Concern

  class_methods do
    def human_enum_collection(enum_name, alphabetical: false)
      collection = send(enum_name.to_s.pluralize).keys.collect do |enum_value|
        [self.human_enum_value(enum_name, enum_value), enum_value]
      end

      alphabetical ? collection.sort_by { |arr| arr.first } : collection
    end

    def human_enum_value(enum_name, enum_value)
      I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
    end
  end

  def human_enum_value(enum_name)
    return unless enum_value = self.send(enum_name)

    self.class.human_enum_value(enum_name, enum_value)
  end
end
