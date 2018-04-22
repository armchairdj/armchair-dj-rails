require "rspec/expectations"

RSpec::Matchers.define :be_assigned_to do |assigned_instance|
  match do |saved_instance|
    expect(assigned_instance).to eq(saved_instance)
  end

  chain :with_attributes do |params|
    @params = params

    expect(assigned_instance).to have_nillable_attributes(@params)
  end

  chain :and_have_errors do |errors|
    @errors = errors

    expect(assigned_instance).to have_errors(@errors)
  end

  chain :and_be_valid do
    @valid = true

    expect(assigned_instance).to be_valid
  end

  chain :and_be_invalid do
    @invalid = true

    expect(assigned_instance).to_not be_valid
  end

  failure_message do |saved_instance|
    message  = "expected #{saved_instance} to be updated as #{assigned_instance}"
    message += " with #{@params}"             if @params
    message += " and be valid"               if @valid
    message += " and be invalid"             if @invalid
    message += " and have errors #{@errors}" if @errors
    message += ", but failed"
  end
end
