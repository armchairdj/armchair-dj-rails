# frozen_string_literal: true

RSpec.shared_examples "an_admin_controller" do
  let(:model_instance) { create_minimal_instance }

  context "included" do
    context "callbacks" do
      pending "verify_authorized"
    end
  end

  context "instance" do
    context "private" do
      describe "#determine_layout" do
        subject { controller.send(:determine_layout) }

        it { is_expected.to eq("admin") }
      end

      describe "#allowed_scopes" do
        subject { described_class.new }

        let(  :model) { subject.send(:model_class   ) }
        let( :scopes) { subject.send(:allowed_scopes) }
        let(   :keys) { scopes.keys   }
        let(   :vals) { scopes.values }

        specify { expect(scopes).to be_a_kind_of(Hash) }

        specify "keys are strings" do
          keys.each { |key| expect(key).to be_a_kind_of(String) }
        end

        specify "values are symbols of scopes" do
          vals.each do |val|
            expect(val).to be_a_kind_of(Symbol)

            expect(model).to respond_to(val)
          end
        end
      end

      pending "allowed_sorts"

      pending "#scoped_collection"

      pending "#scopes_for_view"

      pending "#sorts_for_view"

      pending "#current_scope_value"

      pending "#current_sort_value"

      pending "#reverse_sort"
    end
  end
end
