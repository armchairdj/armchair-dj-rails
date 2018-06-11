# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_alphabetizable_model" do
  context "included" do
    context "scopes" do
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

      specify "self#alpha" do
        expected = ["!", "0 723", "0 alright", "0723", "a", "a", "aa", "z a", "z d c"]
        actual   = collection.alpha.map(&:alpha)

        expect(actual).to eq(expected)
      end

      context "hooks" do
        subject { build_minimal_instance }

        describe "before_save" do
          specify "calls #set_alpha" do
             allow(subject).to receive(:set_alpha).and_call_original
            is_expected.to receive(:set_alpha)

            subject.save!
          end

          describe "#set_alpha" do
            before(:each) do
               allow(subject).to receive(:calculate_alpha_string).and_call_original
              is_expected.to receive(:calculate_alpha_string)
            end

            specify "one part" do
              allow(subject).to receive(:alpha_parts).and_return(["Kate Bush"])

              subject.send(:set_alpha)

              expect(subject.alpha).to eq("kate bush")
            end

            specify "multiple parts" do
              allow(subject).to receive(:alpha_parts).and_return([
                "Kate Bush",
                "Never for Ever"
              ])

              subject.send(:set_alpha)

              expect(subject.alpha).to eq("kate bush never for ever")
            end

            specify "blank parts" do
              allow(subject).to receive(:alpha_parts).and_return([
                "Kate Bush",
                nil,
                "Never for Ever",
                ""
              ])

              subject.send(:set_alpha)

              expect(subject.alpha).to eq("kate bush never for ever")
            end

            specify "nested parts" do
              allow(subject).to receive(:alpha_parts).and_return([
                ["Kate Bush", "Never for Ever"],
                "Remastered Edition"
              ])

              subject.send(:set_alpha)

              expect(subject.alpha).to eq("kate bush never for ever remastered edition")
            end
          end
        end
      end

      context "validations" do
        subject { create_minimal_instance }

        describe "#ensure_alpha" do
          specify "invalid" do
            expect(subject.valid?).to eq(true)
          end

          specify "valid" do
            allow(subject).to receive(:alpha).and_return(nil)

            expect(subject.valid?).to eq(false)

            is_expected.to have_error(base: :missing_alpha)
          end
        end
      end
    end
  end

  context "instance" do
    subject { build_minimal_instance }

    it { is_expected.to respond_to(:alpha_parts) }
  end
end
