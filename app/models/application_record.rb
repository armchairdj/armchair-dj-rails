# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  nilify_blanks before: :validation

  include AtomicallyValidatable
  include BetterEnums

  def self.find_by_sorted_ids(ids)
    return none unless ids.any?

    clause = [
      "CASE",
      ids.map.with_index(0) { |id, i| "WHEN id='#{id}' THEN #{i}" },
      "END"
    ].flatten.join(" ")

    where(id: ids).order(Arel.sql(clause))
  end

  def self.validates_nested_uniqueness_of(*nested_attrs, uniq_attr:, scope: [], error_key: :nested_taken, message: nil)
    validates_each(nested_attrs) do |record, nested_attr, nested_values|
      dupes = Set.new

      nested_values.reject(&:marked_for_destruction?).map do |nested_val|
        dupe            = scope.each.each_with_object({}) { |(k), memo| memo[k] = nested_val.try(k); }
        dupe[uniq_attr] = nested_val.try(uniq_attr)

        if dupes.member?(dupe)
          record.errors.add(nested_attr, error_key, message: message)
        else
          dupes.add(dupe)
        end
      end
    end
  end
end
