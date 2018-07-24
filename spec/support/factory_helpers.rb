# frozen_string_literal: true

# PROBLEM:
#   In complex shared examples, you may need to create many instances of the
#   described class. Having to #let them in the calling spec and pass them in
#   using the block syntax of #it_behaves_like is a pain.
# SOLUTION:
#   Name our factories consistently, with a `minimal_#{model}` flavor and a
#   `complete_#(model}` flavor. Then you can safely use these helpers in your
#   shared examples.

# PROBLEM:
#   Introspecting the model name from different types of shared examples is
#   difficult. The semantics are different for model, controller & policy specs
#   - let alone STI models that override #model_name.
# SOLUTION:
#   Use #determine_model_name method below to introspect common spec types.

module FactoryHelpers

  def determine_model_class
    if described_class.respond_to? :model_name
      # MODELS
      described_class
    elsif described_class.respond_to? :controller_name
      # CONTROLLERS
      described_class.controller_name.classify.constantize
    elsif described_class.to_s.match(/Policy$/)
      # POLICIES
      described_class.to_s.demodulize.gsub(/Policy$/, "").constantize
    else
      raise NotImplementedError.new "cannot find model class in this context"
    end
  end

  def determine_model_name
    if described_class.respond_to? :true_model_name
      # STI MODELS THAT OVERRIDE #model_name
      described_class.true_model_name
    elsif described_class.respond_to? :model_name
      # VANILLA MODELS & PLAIN STI MODELS
      described_class.model_name
    elsif described_class.respond_to? :controller_name
      # CONTROLLERS
      determine_model_class.model_name
    elsif described_class.to_s.match(/Policy$/)
      # POLICIES
      determine_model_class.model_name
    else
      raise NotImplementedError.new "cannot find model name in this context"
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

  def create_minimal_instance(*args)
    create(key_for_minimal, *args)
  end

  def stub_minimal_instance(*args)
    build_stubbed(key_for_minimal, *args)
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

  def create_complete_instance(*args)
    create(key_for_complete, *args)
  end

  def stub_complete_instance(*args)
    build_stubbed(key_for_complete, *args)
  end
end
