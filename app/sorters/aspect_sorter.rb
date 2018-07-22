# frozen_string_literal: true

class AspectSorter < Sorter
  def allowed
    super.merge({
      "Facet" => [aspect_facet_sort_sql, name_sort_sql],
      "Name"  => [name_sort_sql, aspect_facet_sort_sql],
    })
  end

private

  def model_class
    Aspect
  end

  def aspect_facet_sort_sql
    Aspect.alpha_order_clause_for(:facet)
  end
end
