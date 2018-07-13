# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :render_empty_json_500 do
  match do
    expect(response     ).to have_http_status(500)
    expect(response.body).to eq("{}")
  end

  failure_message do
    "expected to render '{}' with status 500 but rendered '#{response.body}' with status #{response.status}"
  end
end
