# frozen_string_literal: true

RSpec::Matchers.define :eager_load do |*associations|
  def testable_instance(obj)
    if obj.respond_to? :first
      obj.first
    else
      obj
    end
  end

  match do
    associations.each do |assoc|
      expect(testable_instance(subject).association(assoc)).to be_loaded
    end
  end

  match_when_negated do
    associations.each do |assoc|
      expect(testable_instance(subject).association(assoc)).to_not be_loaded
    end
  end

  failure_message do |actual|
    "expected #{subject} to eager-load #{associations.inspect} but did not"
  end

  failure_message_when_negated do |actual|
    "expected #{subject} not to eager-load #{associations.inspect} but did"
  end
end
