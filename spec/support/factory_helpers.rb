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
    :"minimal_#{find_model_name.param_key}"
  end

  def key_for_complete
    :"complete_#{find_model_name.param_key}"
  end

  def find_model_name
    if described_class.respond_to? :true_model_name
      # STI models
      described_class.true_model_name
    elsif described_class.respond_to? :model_name
      # Models
      described_class.model_name
    elsif described_class.respond_to? :controller_name
      # Controllers
      described_class.controller_name.classify.constantize.model_name
    elsif described_class.to_s.match(/Policy$/)
      # Policies
      described_class.to_s.demodulize.gsub(/Policy$/, "").constantize.model_name
    else
      raise NotImplementedError.new "cannot find model name in this context"
    end
  end
end
