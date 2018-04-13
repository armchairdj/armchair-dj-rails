RSpec.shared_examples "an atomically validatable model" do
  let(:instance) { create(:"minimal_#{described_class.model_name.param_key}") }

  pending "works"
end
