require 'ffaker'

module StyleGuidesHelper
  def lorem_html_paragraphs(num = 2)
    FFaker::Lorem.paragraphs(num).map { |p| content_tag(:p, p) }.join.html_safe
  end
end
