# frozen_string_literal: true

module Listable
  extend ActiveSupport::Concern

  #############################################################################
  # CLASS.
  #############################################################################

  class_methods do
    def acts_as_listable(acts_as_list_scope)
      acts_as_list scope: acts_as_list_scope, top_of_list: 1

      scope :sorted, -> { joins(acts_as_list_scope).order(:"#{acts_as_list_scope}_id", :position) }
    end

    def reorder_for!(parent, sorted_ids)
      sorted_ids = sorted_ids.map(&:to_i)

      return unless sorted_ids.any?

      to_sort        = find_by_sorted_ids(sorted_ids)
      all_for_parent = parent.send(model_name.collection).ids
      all_ids_found  = to_sort.length == sorted_ids.length
      all_ids_valid  = all_for_parent.sort == sorted_ids.sort

      unless all_ids_found && all_ids_valid
        err = "Bad reorder; ids don't match Got #{sorted_ids} but needed #{all_for_parent}."
        raise ArgumentError.new(err)
      end

      acts_as_list_no_update do
        to_sort.each.with_index(1) { |item, i| item.update!(position: i) }
      end

      # Trigger any logic in parent the relies on position of association
      parent.reload.save
    end
  end
end
