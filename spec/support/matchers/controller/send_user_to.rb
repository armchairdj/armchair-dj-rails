# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :send_user_to do |url|
  match do
    expect(response).to redirect_to(url)
  end

  failure_message do
    "expected to redirect_to #{url}, but did not"
  end
end
