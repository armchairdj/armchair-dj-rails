# frozen_string_literal: true

class CreatorSorter < Ginsu::Sorter
  def allowed
    super.merge({
      "Name"       => name_sort_sql,
      "Primary"    => [creator_primary_sort_sql,    name_sort_sql],
      "Individual" => [creator_individual_sort_sql, name_sort_sql],
    })
  end

private

  def model_class
    Creator
  end

  def creator_individual_sort_sql
    "creators.individual ASC"
  end

  def creator_primary_sort_sql
    "creators.primary ASC"
  end
end
