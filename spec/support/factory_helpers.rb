# frozen_string_literal: true

module FactoryHelpers
  def minimal_attributes(*args)
    attributes_for(key_for_minimal, *args)
  end

  def complete_attributes(*args)
    attributes_for(key_for_complete, *args)
  end

  def build_minimal_instance(*args)
    build(key_for_minimal, *args)
  end

  def create_minimal_instance(*args)
    create(key_for_minimal, *args)
  end

  def build_complete_instance(*args)
    build(key_for_complete, *args)
  end

  def create_complete_instance(*args)
    create(key_for_complete, *args)
  end

  def key_for_minimal
    :"minimal_#{get_constant.model_name.param_key}"
  end

  def key_for_complete
    :"complete_#{get_constant.model_name.param_key}"
  end

  def get_constant
    if described_class.respond_to? :model_name
      # Models
      described_class
    elsif described_class.respond_to? :controller_name
      # Controllers
      described_class.controller_name.classify.constantize
    elsif described_class.to_s.match(/Policy$/)
      # Policies
      described_class.to_s.demodulize.gsub(/Policy$/, "").constantize
    else
      raise NotImplementedError.new "cannot find model name in this context"
    end
  end
end
