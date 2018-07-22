class ScopedAndSortedRelation
  include ActionDispatch::Routing::PolymorphicRoutes
  include Rails.application.routes.url_helpers
  include SortClauses

  #############################################################################
  # CLASS.
  #############################################################################

  def self.reverse_sort(clause)
    parts = clause.split(/, ?/)
    # parts = clause.split(/ *, */)

    if parts[0].match(/DESC/)
      parts[0] = parts[0].gsub("DESC", "ASC")
    elsif parts[0].match(/ASC/)
      parts[0] = parts[0].gsub("ASC", "DESC")
    else
      parts[0] = "#{parts[0]} DESC"
    end

    parts.join(", ")
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  attr_reader :relation
  attr_reader :model_class
  attr_reader :scopes
  attr_reader :sorts
  attr_reader :scope
  attr_reader :sort
  attr_reader :dir
  attr_reader :page

  def initialize(relation, scopes: [], sorts: [], scope: nil, sort: nil, dir: nil, page: nil)
    @relation    = relation
    @model_class = relation.klass

    @scopes = scopes
    @sorts  = sorts

    @scope = scope || allowed_scopes.keys.first
    @sort  = sort  || allowed_sorts.keys.first
    @dir   = dir   || "ASC"
    @page  = page  || "1"
  end

  def resolve
    ensure_valid_scope
    ensure_valid_sort

    relation.send(resolved_scope).order(resolved_sort).page(page)
  end

  def scope_map
    allowed_scopes.keys.each.inject({}) do |memo, (key)|
      memo[key] = {
        :active? => key == scope,
        :url     => polymorphic_path([:admin, model_class], scope: key)
      }
      memo
    end
  end

  def sort_map
    allowed_sorts.keys.each.inject({}) do |memo, (key)|
      active    = key == sort
      link_dir  = active && dir == "ASC" ? "DESC" : "ASC"
      memo[key] = {
        :active? => active,
        :desc?   => dir == "DESC",
        :url     => polymorphic_path([:admin, model_class], scope: scope, sort: key, dir: link_dir)
      }
      memo
    end
  end

private

  def default_allowed_scopes
    { "All" => :all }
  end

  def allowed_scopes
    default_allowed_scopes.merge(scopes)
  end

  def resolved_scope
    allowed_scopes[scope]
  end

  def ensure_valid_scope
    return if allowed_scopes.keys.include?(scope)

    raise Pundit::NotAuthorizedError, "Unknown scope [#{scope}]."
  end

  def default_allowed_sorts
    {
      "Default" => default_sort,
      "ID"      => id_sort
    }
  end

  def allowed_sorts
    default_allowed_sorts.merge(sorts)
  end

  def resolved_sort
    clause = [allowed_sorts[sort]].flatten.join(", ")

    clause = self.class.reverse_sort(clause) if dir == "DESC"

    Arel.sql(clause)
  end

  def ensure_valid_sort
    return if allowed_sorts.keys.include?(sort)

    raise Pundit::NotAuthorizedError, "Unknown sort [#{sort}]."
  end
end
