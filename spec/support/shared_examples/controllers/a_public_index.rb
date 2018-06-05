# frozen_string_literal: true

RSpec.shared_examples "a_public_index" do
  let!(  :param_key) { described_class.controller_name.to_sym }
  let!(:model_class) { described_class.new.send(:model_class) }

  let(         :ids) { 21.times.map { |i| create_minimal_instance(:with_published_post).id } }
  let(   :paginated) { model_class.where(id: ids).for_site }
  let(        :none) { model_class.none.for_site }

  context "without records" do
    before(:each) do
      allow(model_class).to receive(:for_site).and_return(none)

      get :index
    end

    describe "renders" do
      it { is_expected.to successfully_render("#{param_key}/index") }

      specify { expect(assigns(param_key)).to paginate(0).of_total_records(0) }
    end
  end

  context "with records" do
    before(:each) { allow(model_class).to receive(:for_site).and_return(paginated) }

    describe "renders" do
      before(:each) { get :index }

      it { is_expected.to successfully_render("#{param_key}/index") }

      specify { expect(assigns(param_key)).to paginate(20).of_total_records(21) }
    end

    describe "paginates" do
      before(:each) { get :index, params: { page: "2" } }

      it { is_expected.to successfully_render("#{param_key}/index") }

      specify { expect(assigns(param_key)).to paginate(1).of_total_records(21) }
    end
  end
end
