# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_alphabetizable_model" do
  describe "scope-related" do
    describe ".alpha" do
      it "orders by alpha column" do
        expect_any_instance_of(ActiveRecord::Relation).to receive(:order).with(:alpha)

        described_class.alpha
      end
    end

    describe "hooks" do
      let(:instance) { build_minimal_instance }

      it "calls #set_alpha on before_save" do
        allow(instance).to receive(:set_alpha).and_call_original

        instance.save(validate: false)

        expect(instance).to have_received(:set_alpha)
      end

      describe "#set_alpha" do
        subject(:alpha) { instance.alpha }

        before do
          allow(instance).to receive(:alpha_parts).and_return(parts)

          instance.send(:set_alpha)
        end

        context "with one part" do
          let(:parts) { ["Kate Bush"] }

          it { is_expected.to eq("kate bush") }
        end

        context "with multiple parts" do
          let(:parts) { ["Kate Bush", "Never for Ever"] }

          it { is_expected.to eq("kate bush never for ever") }
        end

        context "with blank parts" do
          let(:parts) { ["Kate Bush", nil, "Never for Ever", ""] }

          it { is_expected.to eq("kate bush never for ever") }
        end

        context "with nested parts" do
          let(:parts) { [["Kate Bush", "Never for Ever"], "Remastered Edition"] }

          it { is_expected.to eq("kate bush never for ever remastered edition") }
        end
      end
    end

    describe "validations" do
      let(:instance) { create_minimal_instance }

      describe "#ensure_alpha" do
        it "does nothing when alpha is not nil" do
          expect(instance).to be_valid
        end

        it "sets error when alpha is nil" do
          allow(instance).to receive(:alpha).and_return(nil)

          instance.valid?

          expect(instance).to be_invalid
          expect(instance).to have_error(base: :missing_alpha)
        end
      end
    end
  end

  describe "#alpha_parts" do
    subject(:alpha_parts) { create_minimal_instance.alpha_parts }

    it { is_expected.to be_a_kind_of(Array) }
  end
end
