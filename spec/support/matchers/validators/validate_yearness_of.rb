RSpec::Matchers.define :validate_yearness_of do |property|
  match do
    property = property.to_sym

    good = ["2", "20", "200", "2000", nil, ""]

    bad = ["foo", "-200"]

    good.each do |val|
      subject.send(:"#{property}=", val)

      subject.valid?

      is_expected.to_not have_error(property, :not_a_year)
    end

    bad.each do |val|
      subject.send(:"#{property}=", val)

      subject.valid?

      is_expected.to have_error(property, :not_a_year)
    end
  end

  failure_message do |actual|
    "expected #{actual} to validate urlness of #{property.to_sym} but it did not"
  end
end
