# frozen_string_literal: true

concern :AtomicallyValidatable do
  def valid_attributes?(*attributes)
    attributes = [attributes].flatten.compact

    attributes.each do |attribute|
      self.class.validators_on(attribute).each do |validator|
        validator.validate_each(self, attribute, self[attribute])
      end
    end

    errors.details.slice(*attributes).none?
  end

  def valid_attribute?(attribute)
    valid_attributes?(attribute)
  end
end
