# frozen_string_literal: true

module ApplicationHelper
  def smart_truncate(str, length: nil)
    puts "smart_truncate"

    return str if length.nil?

    h.truncate(str, length: length, omission: "…", separator: " ")
  end
end
