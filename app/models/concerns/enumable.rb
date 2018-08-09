# frozen_string_literal: true

concern :Enumable do

  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    class_attribute :_enumable_attributes, instance_accessor: false

    self._enumable_attributes = []
  end

  #############################################################################
  # CLASS.
  #############################################################################

  class_methods do
    def human_enum_collection(attribute, alphabetical: false, variation: nil)
      collection = send(attribute.to_s.pluralize).keys.collect do |val|
        [self.human_enum_value(attribute, val, variation: variation), val]
      end

      alphabetical ? collection.sort_by(&:first) : collection
    end

    def human_enum_collection_with_keys(attribute, alphabetical: false, variation: nil)
      collection = send(attribute.to_s.pluralize).collect do |val, key|
        [self.human_enum_value(attribute, val, variation: variation), val, key]
      end

      alphabetical ? collection.sort_by(&:first) : collection
    end

    def human_enum_value(attribute, val, variation: nil)
      lookup = [
        "activerecord",
        "attributes",
        model_name.i18n_key,
        attribute.to_s.pluralize,
        variation,
        val
      ].compact.join(".")


      I18n.t(lookup)
    end

    # TODO break out define_instance_methods & define_class_methods

    def enumable_attributes(*attributes)
      self._enumable_attributes = Set.new(attributes.map(&:to_sym))

      attributes.map(&:to_s).each do |attr|
        plural_attr = attr.pluralize

        # Define class methods
        singleton_class.instance_eval do
          define_method :"human_#{plural_attr}_with_keys" do |**opts|
            self.human_enum_collection_with_keys(attr, **opts)
          end

          define_method :"human_#{plural_attr}" do |**opts|
            self.human_enum_collection(attr, **opts)
          end

          define_method :"human_#{attr}" do |val, **opts|
            self.human_enum_value(attr, val, **opts)
          end
        end

        # Define instance methods
        self.class_eval do
          define_method :"human_#{attr}" do
            self.class.send(:"human_#{attr}", self.send(attr))
          end

          define_method :"raw_#{attr}" do
            self.class.send(:"#{plural_attr}")[self.send(attr)]
          end
        end
      end
    end

    def retrieve_enumable_attributes
      self._enumable_attributes
    end

    def alpha_order_clause_for(attribute)
      humanized = human_enum_collection_with_keys(attribute, alphabetical: true)

      whens = humanized.each.with_index.inject([]) do |memo, ((humanized, val, key), index)|
        memo << "WHEN #{attribute}=#{key} THEN #{index}"; memo
      end

      "CASE #{whens.join(" ")} END"
    end
  end
end
