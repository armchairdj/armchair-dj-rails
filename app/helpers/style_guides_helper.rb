# frozen_string_literal: true

require "ffaker"

module StyleGuidesHelper
  def lorem_html_paragraphs(num = 2)
    FFaker::HipsterIpsum.paragraphs(num).map { |p| content_tag(:p, p) }.join("\n").html_safe
  end
end
