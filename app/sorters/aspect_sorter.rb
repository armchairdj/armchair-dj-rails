# frozen_string_literal: true

class AspectSorter < Ginsu::Sorter
  def allowed
    super.merge(
      "Key" => [aspect_key_sort_sql, val_sort_sql],
      "Val" => [val_sort_sql, aspect_key_sort_sql]
    )
  end

private

  def model_class
    Aspect
  end

  def aspect_key_sort_sql
    Aspect.human_key_order_clause
  end
end
