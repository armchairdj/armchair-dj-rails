# frozen_string_literal: true

class InstanceDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all
end
