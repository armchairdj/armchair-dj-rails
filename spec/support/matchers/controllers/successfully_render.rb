require "rspec/expectations"

RSpec::Matchers.define :successfully_render do |template|
  match do
    expect(response).to be_success
    expect(response).to render_template(template)
  end

  chain :with_flash do |type, message|
    @type    = type
    @message = message.nil? ? nil : I18n.t(message)

    if @message.nil?
      expect(flash.now[@type]).to eq(nil)
    else
      expect(controller).to set_flash.now[@type].to(@message)
    end
  end

  chain :assigning do |instance, sym|
    @instance = instance
    @sym      = sym

    expect(assigns(@sym)).to eq(@instance)
  end

  failure_message do
    message  = "expected to successfully render template #{template}"
    message += " with variable #{@sym} for #{@instance}" if @instance && @sym
    message += " with flash #{@type}=#{@message}"        if @type && @message
    message += ", but did not"
  end
end
