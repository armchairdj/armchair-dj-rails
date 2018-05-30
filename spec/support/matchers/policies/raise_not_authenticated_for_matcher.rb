# frozen_string_literal: true

RSpec::Matchers.define :raise_not_authenticated_for do |method|
  match do
    expect {
      subject.send("#{method.to_s}?")
    }.to raise_error(Pundit::NotAuthenticatedError, "must be logged in")
  end
end