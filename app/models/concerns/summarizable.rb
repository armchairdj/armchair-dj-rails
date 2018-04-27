# frozen_string_literal: true

module Summarizable
  extend ActiveSupport::Concern

  included do
    validates :summary, length: { in: 40..320 }, allow_blank: true
  end
end
