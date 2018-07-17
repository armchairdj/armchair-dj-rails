# frozen_string_literal: true

RSpec.shared_examples "an_admin_index" do
  let!(   :template) { "#{described_class.controller_path}/index" }
  let!(  :param_key) { described_class.controller_name.to_sym }
  let!(:model_class) { described_class.new.send(:model_class) }
  let(         :ids) { 3.times.map { |i| create_minimal_instance.id } }
  let(   :paginated) { model_class.for_list.where(id: ids) }
  let(        :none) { model_class.none }

  allowed_scopes = described_class.new.send(:allowed_scopes)
  allowed_sorts  = described_class.new.send(:allowed_sorts ).keys

  allowed_scopes.each do |scope, method|
    describe "for #{scope} scope" do
      context "without records" do
        before(:each) do
          allow( model_class).to receive_message_chain(:for_list, method).and_return(none)
          expect(model_class).to receive_message_chain(:for_list, method)

          get :index, params: { scope: scope }
        end

        describe "renders" do
          it { is_expected.to successfully_render(template) }

          it { expect(assigns(param_key)).to paginate(0).of_total_records(0) }
        end
      end

      context "with records" do
        before(:each) do
          allow( model_class).to receive_message_chain(:for_list, method).and_return(paginated)
          expect(model_class).to receive_message_chain(:for_list, method)
        end

        describe "renders with default sorting" do
          before(:each) do
            get :index, params: { scope: scope }
          end

          it { is_expected.to successfully_render(template) }

          it { expect(assigns(param_key)).to paginate(2).of_total_records(3) }
        end

        describe "paginates" do
          before(:each) do
            get :index, params: { scope: scope, page: "2" }
          end

          it { is_expected.to successfully_render(template) }

          it { expect(assigns(param_key)).to paginate(1).of_total_records(3) }
        end
      end
    end
  end

  allowed_sorts.each do |sort|
    describe "for #{sort} sorting" do
      before(:each) do
        allow( model_class).to receive_message_chain(:for_list, allowed_scopes.values.first).and_return(paginated)
        expect(model_class).to receive_message_chain(:for_list, allowed_scopes.values.first)

        get :index, params: { sort: sort }
      end

      it { is_expected.to successfully_render(template) }

      it { expect(assigns(param_key)).to paginate(2).of_total_records(3) }
    end
  end
end
