# frozen_string_literal: true

RSpec::Matchers.define :raise_not_authorized_for do |method|
  match do
    expect do
      subject.send("#{method.to_s}?")
    end.to raise_error(Pundit::NotAuthorizedError)
  end
end
