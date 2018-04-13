module AtomicallyValidatable
  extend ActiveSupport::Concern

  def valid_attributes?(*attributes)
    attributes.each do |attribute|
      self.class.validators_on(attribute).each do |validator|
        validator.validate_each(self, attribute, self[attribute])
      end
    end

    errors.messages.slice(*attributes).none?
  end

  def valid_attribute?(attribute)
    valid_attributes?(attribute)
  end
end
