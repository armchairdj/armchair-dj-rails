require "rspec/expectations"

RSpec::Matchers.define :successfully_render do |template|
  match do |actual|
    expect(actual).to be_success
    expect(actual).to render_template(template)
  end

  chain :with_flash do |type, message|
    @type    = type
    @message = I18n.t(message)

    expect(controller).to set_flash.now[@type].to(@message)
  end

  failure_message do |actual|
    if @type && @message
      "expected #{actual} to successfully render template #{template} with flash #{@type}=#{@message}, but did not"
    else
      "expected #{actual} to successfully render template #{template}, but did not"
    end
  end
end
