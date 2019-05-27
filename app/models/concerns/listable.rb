# frozen_string_literal: true

concern :Listable do
  #############################################################################
  # Class.
  #############################################################################

  class_methods do
    def acts_as_listable(acts_as_list_scope)
      acts_as_list(scope: acts_as_list_scope, top_of_list: 1)

      scope :sorted, lambda {
        joins(acts_as_list_scope).order(:"#{acts_as_list_scope}_id", :position)
      }
    end

    def reorder_for!(parent, sorted_ids)
      return unless sorted_ids.any?

      BulkReorder.new(self, parent, sorted_ids).execute!
    end
  end

  #############################################################################
  # BulkReorder.
  #############################################################################

  class BulkReorder
    def initialize(model_class, parent, sorted_ids)
      @model_class  = model_class
      @parent       = parent
      @sorted_ids   = sorted_ids.map(&:to_i)

      @expected_ids = find_expected_ids
      @to_reorder   = find_items_in_correct_order
    end

    def execute!
      validate!

      update_position_column

      trigger_parent_hooks
    end

  private

    ### Bootstrapping.

    def find_expected_ids
      @parent.send(association_name).ids
    end

    def association_name
      @model_class.name.demodulize.pluralize.downcase
    end

    def find_items_in_correct_order
      @model_class.find_by_sorted_ids(@sorted_ids)
    end

    ### Validation.

    def validate!
      return if correct_number_of_ids? && expected_ids_found?

      raise ArgumentError, error_message
    end

    def correct_number_of_ids?
      @to_reorder.length == @sorted_ids.length
    end

    def expected_ids_found?
      @expected_ids.sort == @sorted_ids.sort
    end

    def error_message
      "Bad reorder. IDs don't match. Got #{@sorted_ids} but needed #{@expected_ids}."
    end

    ### Database.

    def update_position_column
      @model_class.acts_as_list_no_update do
        @to_reorder.each.with_index(1) { |item, i| item.update!(position: i) }
      end
    end

    def trigger_parent_hooks
      @parent.reload.save
    end
  end
end
