# frozen_string_literal: true

class DicedRelation
  attr_reader :scoper
  attr_reader :sorter

  def initialize(relation, scope: nil, sort: nil, dir: nil, page: nil)
    @relation    = relation
    @model_class = relation.klass.model_name.name.constantize # Works with STI

    @scoper = "#{@model_class}Scoper".constantize.new(scope, sort, dir)
    @sorter = "#{@model_class}Sorter".constantize.new(scope, sort, dir)

    @page = page || "1"
  end

  def resolve
    @relation.send(@scoper.resolve).order(@sorter.resolve).page(@page)
  end
end
