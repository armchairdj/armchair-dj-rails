# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :render_bad_request do
  match do
    expect(response).to have_http_status(422)
    expect(response).to render_template("errors/bad_request")
  end

  failure_message do
    "expected to render bad_request, but did not"
  end
end
