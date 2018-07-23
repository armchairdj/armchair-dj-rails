# frozen_string_literal: true

class DicedRelation
  attr_reader :scoper
  attr_reader :sorter

  def initialize(relation, scope: nil, sort: nil, dir: nil, page: nil)
    @relation    = relation
    @model_class = determine_model_class_even_with_sti

    args = { current_scope: scope, current_sort: sort, current_dir: dir }

    @scoper = "#{@model_class}Scoper".constantize.new(**args)
    @sorter = "#{@model_class}Sorter".constantize.new(**args)

    @page = page || "1"
  end

  def resolve
    @relation.send(@scoper.resolve).order(@sorter.resolve).page(@page)
  end

private

  def determine_model_class_even_with_sti
    @relation.klass.model_name.name.constantize
  end
end
