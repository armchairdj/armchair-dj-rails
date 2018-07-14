# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :render_not_found do
  match do
    expect(response).to have_http_status(404)
    expect(response).to render_template("errors/not_found")
  end

  failure_message do
    "expected to render not_found, but did not (status was #{response.status})"
  end
end
