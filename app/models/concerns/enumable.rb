# frozen_string_literal: true

# Enums are great, but they don't have built-in i18n support in Rails.


concern :Enumable do

  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    class_attribute :_enumable_attributes, instance_accessor: false
  end

  #############################################################################
  # CLASS.
  #############################################################################

  class_methods do
    def add_enumable_attribute(attribute)
      remember_enumable_attribute(attribute)

      single_attr = attribute.to_s
      plural_attr = attribute.to_s.pluralize

      define_class_methods    single_attr, plural_attr
      define_instance_methods single_attr, plural_attr
    end

    def retrieve_enumable_attributes
      self._enumable_attributes
    end

    def remember_enumable_attribute(attribute)
      self._enumable_attributes ||= Set.new
      self._enumable_attributes << attribute.to_sym
    end

    def define_class_methods(single_attr, plural_attr)
      singleton_class.instance_eval do
        # User.human_activities
        define_method :"human_#{plural_attr}" do |**opts|
          human_enumeration(single_attr, **opts)
        end

        # User.human_activity
        define_method :"human_#{single_attr}" do |val, **opts|
          human_enumeration_for(single_attr, val, **opts)
        end

        # User.human_activity_order_clause
        define_method :"human_#{plural_attr}_order_clause" do |**opts|
          human_enumeration_order_clause(single_attr, **opts)
        end
      end
    end

    def define_instance_methods(single_attr, plural_attr)
      self.class_eval do
        # user.human_activity
        define_method :"human_#{single_attr}" do |**opts|
          val = self.send(single_attr)

          self.class.human_enumeration_for(single_attr, val, **opts)
        end

        # user.raw_activity
        define_method :"raw_#{single_attr}" do
          val = self.send(single_attr)

          self.class.send(plural_attr.to_sym)[val]
        end
      end
    end

    def human_enumeration(attribute, alpha: false, include_raw: false, variation: nil)
      plural_attr = attribute.to_s.pluralize

      collection = send(plural_attr).map do |val, raw|
        humanized = human_enumeration_for(attribute, val, variation: variation)

        include_raw ? [humanized, val, raw] : [humanized, val]
      end

      alpha ? collection.sort_by(&:first) : collection
    end

    def human_enumeration_for(attribute, val, variation: nil)
      I18n.t human_i18n_lookup(attribute.to_s.pluralize, val, variation)
    end

    # activerecord.attributes.user.activities.breathe
    # activerecord.attributes.user.activities.short.breathe
    # activerecord.attributes.user.activities.long.breathe
    def human_i18n_lookup(plural_attr, val, variation)
      root = "activerecord.attributes.#{model_name.i18n_key}"

      [root, plural_attr, variation, val].compact.join(".")
    end

    def human_enumeration_order_clause(attribute, variation: nil)
      opts = { alpha: true, include_raw: true, variation: variation }

      humanized = human_enumeration(attribute, **opts)

      whens = humanized.map.with_index do |(humanized, val, raw), index|
        "WHEN #{attribute}=#{raw} THEN #{index}"
      end

      "CASE #{whens.join(" ")} END"
    end
  end
end
