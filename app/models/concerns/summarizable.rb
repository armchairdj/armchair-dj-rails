module Summarizable
  extend ActiveSupport::Concern

  included do
    validates :summary, length: { in: 40..320 }, allow_blank: true
  end
end
