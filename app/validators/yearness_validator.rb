# frozen_string_literal: true

class YearnessValidator < ActiveModel::EachValidator
  YEAR_MIN = 1
  YEAR_MAX = (Date.today.year + 1)

  def validate_each(record, attribute, value)
    return if value.blank?

    good_format = value.to_s.match(/\d{1,4}/i)
    good_year   = (YEAR_MIN..YEAR_MAX).to_a.include?(value.to_i)

    return if good_format && good_year

    record.errors.add(attribute, :not_a_year, year_min: YEAR_MIN, year_max: YEAR_MAX)
  end
end
