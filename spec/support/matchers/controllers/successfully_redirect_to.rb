require "rspec/expectations"

RSpec::Matchers.define :successfully_redirect do |url|
  match do |actual|
    expect(actual).to redirect_to(url)
  end

  chain :with_flash do |type, message|
    @type    = type
    @message = I18n.t(message)

    expect(controller).to set_flash[@type].to(@message)
  end

  failure_message do |actual|
    if @type && @message
      "expected #{actual} to successfully redirect_to #{url} with flash #{@type}=#{@message}, but did not"
    else
      "expected #{actual} to successfully redirect_to #{url}, but did not"
    end
  end
end
