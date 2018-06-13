# frozen_string_literal: true

RSpec.configure do |config|
  # Print slow tests at end of output.
  # config.profile_examples = 10

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true

    expectations.syntax = [:expect]
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  end

#  config.filter_run_including focus: true

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.example_status_persistence_file_path = "tmp/examples.txt"

  config.disable_monkey_patching!

  config.default_formatter = "doc" if config.files_to_run.one?

  config.order = :random

  Kernel.srand config.seed
end
