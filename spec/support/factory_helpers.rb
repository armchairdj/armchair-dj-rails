# frozen_string_literal: true

# PROBLEM:
#   In complex shared examples, we may need to create many instances of the
#   described class. Having to #let them in the calling spec and pass them in
#   using the block syntax of #it_behaves_like is a pain.
# SOLUTION:
#   Name our factories consistently, with a `minimal_#{model}` flavor and a
#   `complete_#(model}` flavor. Then we can safely use these helpers in our
#   shared examples.

# PROBLEM:
#   Introspecting the model name from different types of shared examples is
#   difficult. The semantics are different for model, controller & policy specs
#   - let alone STI models that override #model_name.
# SOLUTION:
#   Use #determine_model_name method below to discern model class from common
#   spec types.

module FactoryHelpers
  POLICY_OR_HELPER_MATCHER = /sHelper|Policy$/.freeze

  def determine_model_class
    # MODELS
    if described_class.respond_to? :model_name
      return described_class
    end

    # CONTROLLERS
    if described_class.respond_to? :controller_name
      return described_class.controller_name.classify.constantize
    end

    # POLICIES & HELPERS
    if described_class.to_s.match?(POLICY_OR_HELPER_MATCHER)
      return described_class.to_s.demodulize.remove(POLICY_OR_HELPER_MATCHER).constantize
    end

    raise NotImplementedError, "cannot find model class in this context"
  end

  def determine_model_name
    model_class = determine_model_class

    # SPECIAL CASING FOR STI MODELS THAT OVERRIDE #model_name.
    if model_class.respond_to? :true_model_name
      model_class.true_model_name
    else
      model_class.model_name
    end
  end

  #############################################################################
  # MINIMAL HELPERS rely on the model having a `:minimal_#{model}` factory.
  #############################################################################

  def key_for_minimal
    :"minimal_#{determine_model_name.param_key}"
  end

  def attributes_for_minimal_instance(*args)
    attributes_for(key_for_minimal, *args)
  end

  def build_minimal_instance(*args)
    build(key_for_minimal, *args)
  end

  def stub_minimal_instance(*args)
    build_stubbed(key_for_minimal, *args)
  end

  def create_minimal_instance(*args)
    create(key_for_minimal, *args)
  end

  def build_minimal_list(*args)
    build_list(key_for_minimal, *args)
  end

  def create_minimal_list(*args)
    create_list(key_for_minimal, *args)
  end

  def ids_for_minimal_list(*args)
    create_minimal_list(*args).map(&:id)
  end

  #############################################################################
  # COMPLETE HELPERS rely on the model having a `:complete_#{model}` factory.
  #############################################################################

  def key_for_complete
    :"complete_#{determine_model_name.param_key}"
  end

  def attributes_for_complete_instance(*args)
    attributes_for(key_for_complete, *args)
  end

  def build_complete_instance(*args)
    build(key_for_complete, *args)
  end

  def stub_complete_instance(*args)
    build_stubbed(key_for_complete, *args)
  end

  def create_complete_instance(*args)
    create(key_for_complete, *args)
  end

  def build_complete_list(*args)
    build_list(key_for_complete, *args)
  end

  def create_complete_list(*args)
    create_list(key_for_complete, *args)
  end

  def ids_for_complete_list(*args)
    create_complete_list(*args).map(&:id)
  end
end
