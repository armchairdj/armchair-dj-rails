# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :successfully_render do |template|
  match do
    expect(response).to have_http_status(200)
    expect(response).to render_template(template)
  end

  failure_message do
    "expected to successfully render template #{template}, but did not"
  end
end
