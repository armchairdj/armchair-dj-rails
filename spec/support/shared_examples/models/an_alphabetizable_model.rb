# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_alphabetizable_model" do
  describe "included" do
    describe "scopes" do
      let!(:alphas) { ["AA", "A", "Z D C", "0 723", "!", "a", "Z a", "0 Alright", "0723"] }

      let!(:collection) do
        instances = []

        alphas.length.times do |n|
          instance = create_minimal_instance

          instance.update_column(:alpha, alphas[n].downcase)

          instances << instance
        end

        described_class.where(id: instances.map(&:id))
      end

      describe "self#alpha" do
        subject { collection.alpha.map(&:alpha) }

        let(:expected) { ["!", "0 723", "0 alright", "0723", "a", "a", "aa", "z a", "z d c"] }

        it { is_expected.to eq(expected) }
      end

      describe "hooks" do
        let(:instance) { build_minimal_instance }

        describe "before_save" do
          it "calls #set_alpha" do
            allow( instance).to receive(:set_alpha)
            expect(instance).to receive(:set_alpha)

            instance.save
          end
        end

        describe "#set_alpha" do
          subject { instance.alpha }

          before(:each) do
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
            let(:parts) { [ ["Kate Bush", "Never for Ever"], "Remastered Edition" ] }

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
            before(:each) do
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
    subject { build_minimal_instance.alpha_parts }

    it { is_expected.to be_a_kind_of(Array) }
  end
end
