# frozen_string_literal: true

module Ginsu
  class Sorter < Knife
    #############################################################################
    # CLASS.
    #############################################################################

    def self.prepare_clause(clauses, dir)
      clauses = [*clauses]

      if dir == "DESC"
        clauses[0] = reverse_clause(clauses[0])
      end

      Arel.sql(combine_clauses(clauses))
    end

    def self.reverse_clause(clause)
      clause = clause.squish

      return clause.gsub("DESC", "ASC") if clause =~ /DESC$/
      return clause.gsub("ASC", "DESC") if clause =~ /ASC$/

      "#{clause} DESC"
    end

    def self.combine_clauses(clauses)
      clauses.map(&:squish).join(", ")
    end

    #############################################################################
    # INSTANCE.
    #############################################################################

    def initialize(current_scope: nil, current_sort: nil, current_dir: nil)
      current_scope = nil                if current_scope.blank?
      current_sort  = allowed.keys.first if current_sort.blank?
      current_dir   = "ASC"              if current_dir.blank?

      super(current_scope: current_scope, current_sort: current_sort, current_dir: current_dir)
    end

    def resolved
      validate

      self.class.prepare_clause(allowed[@current_sort], @current_dir)
    end

    def map
      allowed.keys.each.each_with_object({}) do |(sort), memo|
        active = sort == @current_sort
        desc   = active && @current_dir == "DESC"
        dir    = active && @current_dir == "ASC" ? "DESC" : "ASC"
        url    = diced_url(@current_scope, sort, dir)

        memo[sort] = { active?: active, desc?: desc, url: url }
      end
    end

    def allowed
      {
        "Default" => default_sort_sql,
        "ID"      => id_sort_sql
      }
    end

  private

    def valid?
      return false unless allowed.key?(@current_sort)
      return false unless ["ASC", "DESC"].include?(@current_dir)

      true
    end

    def invalid_msg
      I18n.t("exceptions.sorter.invalid", model: model_class, sort: @current_sort, dir: @current_dir)
    end

    def alpha_sort_sql
      "#{model_class.table_name}.alpha ASC"
    end

    def default_sort_sql
      "#{model_class.table_name}.updated_at DESC"
    end

    def id_sort_sql
      "#{model_class.table_name}.id ASC"
    end

    def name_sort_sql
      "LOWER(#{model_class.table_name}.name) ASC"
    end

    def title_sort_sql
      "LOWER(#{model_class.table_name}.title) ASC"
    end

    def author_sort_sql
      "users.username ASC"
    end

    def work_medium_sort_sql
      "LOWER(works.medium) ASC"
    end
  end
end
