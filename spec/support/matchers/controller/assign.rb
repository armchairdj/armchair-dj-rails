# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :assign do |instance, sym|
  match do
    expect(instance).to eq(assigns(sym))
  end

  chain :with_attributes do |params|
    @params = params

    expect(assigns(sym)).to have_coerced_attributes(@params)
  end

  chain :with_errors do |errors|
    @errors = errors

    expect(assigns(sym)).to have_error(@errors)
  end

  chain :and_be_valid do
    @valid = true

    expect(assigns(sym).errors).to be_empty
  end

  chain :and_be_invalid do
    @invalid = true

    expect(assigns(sym).errors).to_not be_empty
  end

  failure_message do
    message  = "expected #{instance} to be assigned as #{sym}"
    message += " with #{@params}"            if @params
    message += " and be valid"               if @valid
    message += " and be invalid"             if @invalid
    message += " and have errors #{@errors}" if @errors

    message + ", but failed"
  end
end
