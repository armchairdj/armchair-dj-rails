# frozen_string_literal: true

module Enumable
  extend ActiveSupport::Concern

  class_methods do
    def human_enum_collection(attribute, alphabetical: false)
      collection = send(attribute.to_s.pluralize).keys.collect do |val|
        [self.human_enum_value(attribute, val), val]
      end

      alphabetical ? collection.sort_by(&:first) : collection
    end

    def human_enum_collection_with_keys(attribute, alphabetical: false)
      collection = send(attribute.to_s.pluralize).collect do |val, key|
        [self.human_enum_value(attribute, val), val, key]
      end

      alphabetical ? collection.sort_by(&:first) : collection
    end

    def human_enum_value(attribute, val)
      I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{attribute.to_s.pluralize}.#{val}")
    end

    def enumable_attributes(*attributes)
      self._enumable_attributes = Set.new(attributes.map(&:to_sym))

      attributes.map(&:to_s).each do |attribute|

        # Define class methods
        singleton_class.instance_eval do
          define_method :"human_#{attribute.pluralize}_with_keys" do
            self.human_enum_collection_with_keys(attribute)
          end

          define_method :"human_#{attribute.pluralize}" do
            self.human_enum_collection(attribute)
          end

          define_method :"alphabetical_human_#{attribute.pluralize}" do
            self.human_enum_collection(attribute, alphabetical: true)
          end

          define_method :"human_#{attribute}" do |val|
            self.human_enum_value(attribute, val)
          end
        end

        # Define instance methods
        self.class_eval do
          define_method :"human_#{attribute}" do
            self.class.send(:"human_#{attribute}", self.send(attribute))
          end
        end
      end
    end

    def retrieve_enumable_attributes
      self._enumable_attributes
    end
  end

  included do
    class_attribute :_enumable_attributes, instance_accessor: false

    self._enumable_attributes = []
  end
end
