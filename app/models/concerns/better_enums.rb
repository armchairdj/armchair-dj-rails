# frozen_string_literal: true

# Rails enums are great, but they don't have built-in i18n support.
#
# Wouldn't it be great to be able to:
#
#   - translate enums automatically?
#   - sort collections by translated value?
#   - choose from translation variations in different context?
#   - easily use translated enums in dropdowns and radio buttons?
#   - easily retrieve raw enum values?

concern :BetterEnums do
  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    class_attribute :_better_enums, instance_accessor: false

    private_class_method :lazy_load_better_enums
    private_class_method :define_better_enum_class_methods
    private_class_method :define_better_enum_instance_methods
    private_class_method :human_enum
    private_class_method :human_enum_member
    private_class_method :human_enum_lookups
    private_class_method :human_enum_lookup
    private_class_method :human_enum_alpha_order_clause
    private_class_method :sorted_by_human_enum
    private_class_method :raw_enum_member
  end

  #############################################################################
  # CLASS.
  #############################################################################

  class_methods do
    ##############
    ### PUBLIC ###
    ##############

    def improve_enum(attribute)
      lazy_load_better_enums

      _better_enums << attribute.to_sym

      single_attr = attribute.to_s
      plural_attr = attribute.to_s.pluralize

      define_better_enum_class_methods    single_attr, plural_attr
      define_better_enum_instance_methods single_attr, plural_attr
    end

    def better_enums
      lazy_load_better_enums

      _better_enums
    end

    ###############
    ### PRIVATE ###
    ###############

    def lazy_load_better_enums
      self._better_enums ||= Set.new
    end

    def define_better_enum_class_methods(single_attr, plural_attr)
      singleton_class.instance_eval do
        # User#human_activities
        define_method :"human_#{plural_attr}" do |**opts|
          human_enum(single_attr, **opts)
        end

        # User#human_activity
        define_method :"human_#{single_attr}" do |val, **opts|
          human_enum_member(single_attr, val, **opts)
        end

        # User#human_activity_order_clause
        define_method :"human_#{single_attr}_order_clause" do |**opts|
          human_enum_alpha_order_clause(single_attr, **opts)
        end

        # User#sorted_by_human_activity
        define_method :"sorted_by_human_#{single_attr}" do |**opts|
          sorted_by_human_enum(single_attr, **opts)
        end
      end
    end

    def define_better_enum_instance_methods(single_attr, _plural_attr)
      class_eval do
        # user#human_activity
        define_method :"human_#{single_attr}" do |**opts|
          val = send(single_attr)

          self.class.send(:human_enum_member, single_attr, val, **opts)
        end

        # user#raw_activity
        define_method :"raw_#{single_attr}" do
          val = send(single_attr)

          self.class.send(:raw_enum_member, single_attr, val)
        end
      end
    end

    def human_enum(attribute, alpha: false, include_raw: false, variation: nil)
      plural_attr = attribute.to_s.pluralize

      collection = send(plural_attr).map do |val, raw|
        humanized = human_enum_member(attribute, val, variation: variation)

        include_raw ? [humanized, raw, val] : [humanized, val]
      end

      alpha ? collection.sort_by(&:first) : collection
    end

    def human_enum_member(attribute, val, variation: nil)
      humanized = nil
      lookups   = human_enum_lookups(attribute.to_s.pluralize, val, variation)

      lookups.each do |lookup|
        humanized = I18n.t lookup

        break unless humanized =~ /translation missing/i
      end

      humanized
    end

    # activerecord.attributes.admin.activities.breathe
    # activerecord.attributes.user.activities.breathe
    # activerecord.attributes.admin.activities.short.breathe
    # activerecord.attributes.user.activities.short.breathe
    def human_enum_lookups(plural_attr, val, variation, model_class = nil)
      model_class ||= self

      lookups = []

      while model_class != ApplicationRecord
        lookups << human_enum_lookup(plural_attr, val, variation, model_class)

        model_class = model_class.superclass
      end

      lookups
    end

    def human_enum_lookup(plural_attr, val, variation, model_class)
      root = "activerecord.attributes.#{model_class.model_name.i18n_key}"

      [root, plural_attr, variation, val].compact.join(".")
    end

    def human_enum_alpha_order_clause(attribute, variation: nil)
      opts = { alpha: true, include_raw: true, variation: variation }

      humanized = human_enum(attribute, **opts)

      whens = humanized.map.with_index do |(_human, raw, _val), index|
        "WHEN #{attribute}=#{raw} THEN #{index}"
      end

      "CASE #{whens.join(" ")} END"
    end

    def sorted_by_human_enum(attribute, variation: nil)
      clause = human_enum_alpha_order_clause(attribute, variation: variation)

      order(Arel.sql(clause))
    end

    def raw_enum_member(attribute, val)
      send(attribute.to_s.pluralize.to_sym)[val]
    end
  end
end
