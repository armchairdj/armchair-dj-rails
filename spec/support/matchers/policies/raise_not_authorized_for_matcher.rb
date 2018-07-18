# frozen_string_literal: true

RSpec::Matchers.define :raise_not_authorized_for do |method|
  match do
    expect {
      subject.send("#{method.to_s}?")
    }.to raise_error(Pundit::NotAuthorizedError, "cannot access cms")
  end
end
