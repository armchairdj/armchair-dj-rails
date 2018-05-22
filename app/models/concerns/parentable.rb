# frozen_string_literal: true

module Parentable
  extend ActiveSupport::Concern

  included do
    has_ancestry cache_depth: true, orphan_strategy: :rootify
  end

  class_methods do
    def arrange_as_array(options = {}, hash = nil)
      hash ||= arrange(options)

      hash.each.inject([]) do |memo, (node, children)|
        memo << node
        memo += arrange_as_array(options, children) unless children.nil?
        memo
      end
    end
  end

  def parent_dropdown_options(order = :alpha)
    self.class.arrange_as_array({ order: order }, self.possible_parents)
  end

  def text_for_parent_dropdown(name_method, separator = nil)
    parts = []

    parts << "#{separator * self.depth}" unless separator.nil?
    parts << self.send(name_method)

    parts.join(" ")
  end

  def possible_parents(order = :alpha)
    parents = self.class.arrange_as_array(order: order)

    new_record? ? parents : parents - subtree
  end
end
