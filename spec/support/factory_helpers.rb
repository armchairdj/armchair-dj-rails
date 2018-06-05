# frozen_string_literal: true

module FactoryHelpers
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
    if described_class.respond_to? :controller_name
      described_class.controller_name.classify.constantize
    else
      described_class
    end
  end
end
