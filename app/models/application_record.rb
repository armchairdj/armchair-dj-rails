# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  nilify_blanks before: :validation

  include AtomicallyValidatable
  include Enumable

  def self.admin_scopes
    { "All" => :for_admin }
  end

  def self.default_admin_scope
    self.admin_scopes.values.first
  end

  def self.find_by_sorted_ids(ids)
    return self.none unless ids.any?

    clause = ["CASE"]
    ids.each.with_index(0) { |id, i| clause << "WHEN id='#{id}' THEN #{i}" }
    clause << "END"

    self.where(id: ids).order(Arel.sql(clause.join(" ")))
  end

  def self.validate_nested_uniqueness_of(*nested_attrs)
    opts      = nested_attrs.extract_options!
    uniq_attr = opts[:uniq_attr]
    scope     = opts[:scope    ] || []
    error_key = opts[:error_key] || :nested_taken
    message   = opts[:message  ] || nil

    raise ArgumentError unless uniq_attr.present?

    validates_each(nested_attrs) do |record, nested_attr, nested_values|
      dupes = Set.new

      nested_values.reject(&:marked_for_destruction?).map do |nested_val|
        dupe            = scope.each.inject({}) { |memo, (k)| memo[k] = nested_val.try(k); memo }
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
