# frozen_string_literal: true

class WorkSorter < Sorter
  def allowed
    super.merge({
      "Title"   => title_sort_sql,
      "Makers" =>  [work_maker_sort_sql,  title_sort_sql],
      "Medium"  => [work_medium_sort_sql, title_sort_sql],
    })
  end

private

  def model_class
    Work
  end

  def work_maker_sort_sql
    "LOWER(works.display_makers) ASC"
  end
end
