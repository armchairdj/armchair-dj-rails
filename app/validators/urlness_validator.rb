# frozen_string_literal: true

class UrlnessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      valid_url = URI.parse(value).is_a?(URI::HTTP)
    rescue URI::InvalidURIError
      valid_url = false
    ensure
      record.errors.add(attribute, :not_a_url) unless valid_url
    end
  end
end
