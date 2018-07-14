# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :have_flash do |type, key|
  match do
    msg = key.nil? ? nil : I18n.t(key)

    expect(controller).to set_flash[type].to(msg)
  end
end

RSpec::Matchers.define :have_flash_now do |type, key|
  match do
    msg = key.nil? ? nil : I18n.t(key)

    if key.nil?
      expect(flash.now[type]).to eq(nil)
    else
      expect(controller).to set_flash.now[type].to(msg)
    end
  end
end
