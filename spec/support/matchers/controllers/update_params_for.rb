require "rspec/expectations"

RSpec::Matchers.define :update_params_for do |instance|
  match do |actual|
    expect(actual).to eq(instance)

    if @valid
      expect(actual).to be_valid
    elsif @invalid
      expect(actual).to_not be_valid
    end

    @params.each do |key, val|
      if val.blank?
        expect(actual.send(key)).to be_blank
      else
        expect(actual.send(key)).to eq(val)
      end
    end if @params

    @errors.each do |key, val|
      expect(actual.errors.details[key].first).to eq({ error: val })
    end if @errors

    true
  end

  chain :with do |params|
    @params = params
  end

  chain :and_be_valid do
    @valid = true
  end

  chain :and_be_invalid do
    @invalid = true
  end

  chain :setting_errors do |errors|
    @errors = errors
  end

  failure_message do |actual|
    message  = "expected #{actual} to update #{instance} with #{@params}"
    message += " and be valid"   if @valid
    message += " and be invalid" if @invalid
    message += ", but failed"
  end
end
