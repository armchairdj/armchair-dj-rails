# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_alphabetizable_model" do
  describe "included" do
    describe "scope-related" do
      describe ".alpha" do
        it "orders by alpha column" do
          expect_any_instance_of(ActiveRecord::Relation).to receive(:order).with(:alpha)

          described_class.alpha
        end
      end

      describe "hooks" do
        let(:instance) { build_minimal_instance }

        describe "before_save" do
          it "calls #set_alpha" do
            expect(instance).to receive(:set_alpha)

            instance.save
          end
        end

        describe "#set_alpha" do
          subject { instance.alpha }

          before do
            allow(instance).to receive(:alpha_parts).and_return(parts)

            instance.send(:set_alpha)
          end

          describe "with one part" do
            let(:parts) { ["Kate Bush"] }

            it { is_expected.to eq("kate bush") }
          end

          describe "with multiple parts" do
            let(:parts) { ["Kate Bush", "Never for Ever"] }

            it { is_expected.to eq("kate bush never for ever") }
          end

          describe "with blank parts" do
            let(:parts) { ["Kate Bush", nil, "Never for Ever", ""] }

            it { is_expected.to eq("kate bush never for ever") }
          end

          describe "with nested parts" do
            let(:parts) { [["Kate Bush", "Never for Ever"], "Remastered Edition"] }

            it { is_expected.to eq("kate bush never for ever remastered edition") }
          end
        end
      end

      describe "validations" do
        subject { create_minimal_instance }

        describe "#ensure_alpha" do
          describe "with alpha" do
            it { is_expected.to be_valid }
          end

          describe "without alpha" do
            before do
              allow(subject).to receive(:alpha).and_return(nil)

              subject.valid?
            end

            it { is_expected.to be_invalid }

            it { is_expected.to have_error(base: :missing_alpha) }
          end
        end
      end
    end
  end

  describe "instance" do
    subject { create_minimal_instance.alpha_parts }

    it { is_expected.to be_a_kind_of(Array) }
  end
end
