# frozen_string_literal: true

RSpec.shared_examples "a_ginsu_index" do |template_override|
  let(:param_key) { described_class.controller_name.to_sym }
  let(:template) { template_override || "#{described_class.controller_path}/index" }
  let(:model_class) { described_class.new.send(:determine_model_class) }

  let(:paginated) { model_class.where(id: ids_for_minimal_list(3)) }
  let(:none) { model_class.none }

  context "without records" do
    before do
      allow_any_instance_of(Ginsu::Collection).to receive(:prepare_relation).and_return(none)

      get :index
    end

    it { is_expected.to successfully_render(template) }

    specify { expect(assigns(param_key)).to paginate(0).of_total_records(0) }
  end

  context "with records" do
    before { allow_any_instance_of(Ginsu::Collection).to receive(:prepare_relation).and_return(paginated) }

    context "with page 1" do
      before { get :index }

      it { is_expected.to successfully_render(template) }

      specify { expect(assigns(param_key)).to paginate(2).of_total_records(3) }
    end

    context "with page 2" do
      before { get :index, params: { page: "2" } }

      it { is_expected.to successfully_render(template) }

      specify { expect(assigns(param_key)).to paginate(1).of_total_records(3) }
    end
  end
end
