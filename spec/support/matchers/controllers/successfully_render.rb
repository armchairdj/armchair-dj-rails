require "rspec/expectations"

RSpec::Matchers.define :successfully_render do |template|
  match do
    expect(response).to be_success
    expect(response).to render_template(template)
  end

  chain :with_flash do |type, message|
    @type    = type
    @message = I18n.t(message)

    expect(controller).to set_flash.now[@type].to(@message)
  end

  chain :assigning do |instance|
    @instance = instance
  end

  chain :as do |sym|
    @sym = sym

    expect(assigns(@sym)).to eq(@instance)
  end

  failure_message do
    message  = "expected to successfully render template #{template}"
    message += " with variable #{@sym} for #{@instance}" if @instance && @sym
    message += " with flash #{@type}=#{@message}"        if @type && @message
    message += ", but did not"
  end
end
