module Enumable
  extend ActiveSupport::Concern

  class_methods do
    def human_enum_value(enum_name, enum_value, short: false)
      key = short ? "#{enum_name.to_s.pluralize}_short" : enum_name.to_s.pluralize

      I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{key}.#{enum_value}")
    end

    def human_enum_collection(enum_name)
      send(enum_name.to_s.pluralize).keys.collect do |enum_value|
        [human_enum_value(enum_name, enum_value), enum_value]
      end
    end
  end

  def human_enum_value(enum_name, short: false)
    return unless value = self.send(enum_name)

    self.class.human_enum_value(enum_name, value, short: short)
  end
end
