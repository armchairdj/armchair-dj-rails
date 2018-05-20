RSpec::Matchers.define :validate_urlness_of do |property|
  match do
    property = property.to_sym

    good = [
      "http://foo.bar.com",
      "https://foo.bar.com/baz/bat/1?whatever=something",
      nil,
      ""
    ]

    bad = [
      "foo",
      "http.foo.com"
    ]

    good.each do |val|
      subject.send(:"#{property}=", val)

      subject.valid?

      expect(subject).to_not have_error(property, :not_a_url)
    end

    bad.each do |val|
      subject.send(:"#{property}=", val)

      subject.valid?

      expect(subject).to have_error(property, :not_a_url)
    end
  end

  failure_message do |actual|
    "expected #{actual} to validate urlness of #{property.to_sym} but it did not"
  end
end
