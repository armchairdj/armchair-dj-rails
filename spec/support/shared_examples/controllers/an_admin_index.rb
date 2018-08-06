# frozen_string_literal: true

RSpec.shared_examples "an_admin_index" do
  let(:param_key  ) { described_class.controller_name.to_sym }
  let(:template   ) { "#{described_class.controller_path}/index" }
  let(:model_class) { described_class.new.send(:determine_model_class) }

  let(:paginated) { model_class.where(id: ids_for_minimal_list(3)) }
  let(:none     ) { model_class.none }

  context "without records" do
    before(:each) do
      allow_any_instance_of(Ginsu::Collection).to receive(:prepare_relation).and_return(none)

      get :index
    end

    it { is_expected.to successfully_render(template) }

    specify { expect(assigns(param_key)).to paginate(0).of_total_records(0) }
  end

  context "with records" do
    before(:each) { allow_any_instance_of(Ginsu::Collection).to receive(:prepare_relation).and_return(paginated) }

    context "page 1" do
      before(:each) { get :index }

      it { is_expected.to successfully_render(template) }

      specify { expect(assigns(param_key)).to paginate(2).of_total_records(3) }
    end

    context "page 2" do
      before(:each) { get :index, params: { page: "2" } }

      it { is_expected.to successfully_render(template) }

      specify { expect(assigns(param_key)).to paginate(1).of_total_records(3) }
    end
  end
end
