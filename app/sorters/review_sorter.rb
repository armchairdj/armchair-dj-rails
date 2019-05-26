# frozen_string_literal: true

class ReviewSorter < PostSorter
  def allowed
    super.merge(
      "Medium" => [work_medium_sort_sql, alpha_sort_sql]
    )
  end

private

  def model_class
    Review
  end
end
