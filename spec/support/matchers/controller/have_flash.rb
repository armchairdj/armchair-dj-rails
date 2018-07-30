# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :have_flash do |type, key, **replacements|
  match do
    expect(controller).to set_flash[type].to(msg(key, **replacements))
  end

  def msg(key, **replacements)
    key.nil? ? nil : I18n.t(key, **replacements)
  end

  failure_message do |actual|
    "expected flash[#{type}] to be '#{msg(key, **replacements)}', but it was '#{flash[type.to_sym]}'"
  end
end

RSpec::Matchers.define :have_flash_now do |type, key|
  match do
    expect(controller).to set_flash.now[type].to(msg(key, **replacements))
  end

  def msg(key, **replacements)
    key.nil? ? nil : I18n.t(key, **replacements)
  end

  failure_message do |actual|
    "expected flash.now[#{type}] to be '#{msg(key, **replacements)}', but it was '#{flash.now[type.to_sym]}'"
  end
end
