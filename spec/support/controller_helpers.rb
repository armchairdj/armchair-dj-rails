# frozen_string_literal: true

module ControllerHelpers
  def build_minimal_instance(*args)
    build(key_for_minimal_factory, *args)
  end

  def create_minimal_instance(*args)
    create(key_for_minimal_factory, *args)
  end

  def current_model_name
    described_class.controller_name.classify.constantize.model_name.param_key
  end

  def key_for_minimal_factory
    :"minimal_#{current_model_name}"
  end
end
