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

      describe "scope helpers" do
        subject { described_class.new }

        let(  :model) { subject.send(:model_class   ) }
        let(:default) { subject.send(:default_scope ) }
        let( :scopes) { subject.send(:allowed_scopes) }
        let(   :keys) { scopes.keys   }
        let(   :vals) { scopes.values }

        describe "#allowed_scopes" do
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

        describe "#default_scope" do
          specify { expect(default).to be_a_kind_of(Symbol) }

          specify { expect(default).to eq(scopes.values.first) }

          specify { expect(model).to respond_to(default) }
        end

        pending "allowed_scope?"
      end

      pending "allowed_sorts"

      pending "default_sort"

      pending "allowed_sort?"

      pending "#scoped_and_sorted_collection"
    end
  end
end
