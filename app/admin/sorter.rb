# frozen_string_literal: true

class Sorter < Dicer

  #############################################################################
  # CONSTANTS.
  #############################################################################

  JOINER       = ", ".freeze
  ALLOWED_DIRS = ["ASC", "DESC"].freeze

  #############################################################################
  # INSTANCE.
  #############################################################################

  def initialize(current_scope: nil, current_sort: nil, current_dir: nil)
    current_scope = nil                if current_scope.blank?
    current_sort  = allowed.keys.first if current_sort.blank?
    current_dir   = "ASC"              if current_dir.blank?

    super(current_scope: current_scope, current_sort: current_sort, current_dir: current_dir)
  end

  def resolve
    validate

    sql = [allowed[@current_sort]].flatten
    sql = sql.map(&:squish).join(JOINER)
    sql = reverse_first_clause(sql) if @current_dir == "DESC"

    Arel.sql(sql)
  end

  def map
    allowed.keys.each.inject({}) do |memo, (sort)|
      active = sort == @current_sort
      desc   = active && @current_dir == "DESC"
      dir    = active && @current_dir == "ASC" ? "DESC" : "ASC"
      url    = diced_url(@current_scope, sort, dir)

      memo[sort] = { :active? => active, :desc? => desc, :url => url }
      memo
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
    return false unless allowed.keys.include?(@current_sort)
    return false unless ALLOWED_DIRS.include?(@current_dir)

    true
  end

  def invalid_msg
    I18n.t("exceptions.sorter.invalid", model: model_class, sort: @current_sort, dir: @current_dir)
  end

  def reverse_first_clause(compound_sort_clause)
    parts = compound_sort_clause.split(JOINER)

    parts[0] = reverse_sort(parts[0])

    parts.join(JOINER)
  end

  def reverse_sort(clause)
    return clause.gsub("DESC", "ASC") if clause.match(/DESC$/)
    return clause.gsub("ASC", "DESC") if clause.match(/ASC$/)

    "#{clause} DESC"
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
