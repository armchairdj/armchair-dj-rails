# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :render_internal_server_error do
  match do
    expect(response).to have_http_status(500)
    expect(response).to render_template("errors/internal_server_error")
  end

  failure_message do
    "expected to render internal_server_error, but did not"
  end
end
