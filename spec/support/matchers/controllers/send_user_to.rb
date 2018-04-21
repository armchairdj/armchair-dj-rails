require "rspec/expectations"

RSpec::Matchers.define :send_user_to do |url|
  match do
    expect(response).to redirect_to(url)
  end

  chain :with_flash do |type, message|
    @type    = type
    @message = I18n.t(message)

    expect(controller).to set_flash[@type].to(@message)
  end

  failure_message do
    if @type && @message
      "expected to redirect_to #{url} with flash #{@type}=#{@message}, but did not"
    else
      "expected to redirect_to #{url}, but did not"
    end
  end
end
