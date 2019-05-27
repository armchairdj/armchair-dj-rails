# frozen_string_literal: true

RSpec::Matchers.define :raise_not_authenticated_for do |method|
  match do
    expect do
      subject.send("#{method}?")
    end.to raise_error(Pundit::NotAuthenticatedError, "must be logged in")
  end
end
