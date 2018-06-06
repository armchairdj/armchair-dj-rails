# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :render_permission_denied do
  match do
    expect(response).to have_http_status(403)
    expect(response).to render_template("errors/permission_denied")
  end

  failure_message do
    "expected to render permission_denied, but did not"
  end
end
