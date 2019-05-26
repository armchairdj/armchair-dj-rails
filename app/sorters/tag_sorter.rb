# frozen_string_literal: true

class TagSorter < Ginsu::Sorter
  def allowed
    super.merge(
      "Name" => [name_sort_sql]
    )
  end

private

  def model_class
    Tag
  end
end
