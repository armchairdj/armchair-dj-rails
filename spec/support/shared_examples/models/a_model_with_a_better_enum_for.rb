# frozen_string_literal: true

RSpec.shared_examples "a_model_with_a_better_enum_for" do |enum|
  missing_translation = /translation missing/i

  if enum.is_a?(Hash)
    attribute  = enum[:attribute ]
    variations = enum[:variations]
  else
    attribute  = enum
    variations = []
  end

  single   = attribute.to_s
  plural   = single.pluralize
  i18n_key = "activerecord.attributes.#{described_class.model_name.i18n_key}.#{plural}"

  it { is_expected.to define_enum_for(attribute) }

  describe "generic public class methods" do
    subject { described_class }

    it { is_expected.to respond_to(:improve_enum) }

    describe "self#better_enums" do
      subject { described_class.better_enums }

      it "reports which attributes have been defined" do
        is_expected.to include(attribute)
      end
    end
  end

  describe "i18n for #{single}" do
    described_class.send(plural).keys.each do |val|
      it "has a localized string for #{val}" do
        actual = described_class.send(:"human_#{single}", val)

        expect(actual).to_not match(missing_translation)
      end

      variations.each do |variation|
        it "has a localized string for #{val} with variation #{variation}" do
          actual = described_class.send(:"human_#{single}", val, variation: variation)

          expect(actual).to_not match(missing_translation)
        end
      end
    end
  end

  describe "dynamically defined methods for #{single}" do
    before(:each) do
      allow(described_class).to receive(plural).and_return(
        "init" => 0,
        "addl" => 1,
      )

      allow(I18n).to receive(:t).and_call_original
      allow(I18n).to receive(:t).with("#{i18n_key}.init").and_return("Initial Humanized Value")
      allow(I18n).to receive(:t).with("#{i18n_key}.addl").and_return("Additional Humanized Value")

      allow(I18n).to receive(:t).with("#{i18n_key}.short.init").and_return("Compact Initial")
      allow(I18n).to receive(:t).with("#{i18n_key}.short.addl").and_return("Short Additional")
    end

    describe "at the class level" do
      describe "self#human_#{plural}" do
        context "default behavior" do
          subject { described_class.send(:"human_#{plural}") }

          let(:expected) do
            [["Initial Humanized Value",    "init"],
             ["Additional Humanized Value", "addl"]]
          end

          it "gives a 2D array mapping humanized values to enum values for use in dropdowns" do
            is_expected.to eq(expected)
          end
        end

        context "with the keyword argument alpha: true" do
          subject { described_class.send(:"human_#{plural}", alpha: true) }

          let(:expected) do
            [["Additional Humanized Value", "addl"],
             ["Initial Humanized Value",    "init"]]
          end

          it "alphabetizes by humanized string" do
            is_expected.to eq(expected)
          end
        end

        context "with the keyword argument include_raw: true" do
          subject { described_class.send(:"human_#{plural}", include_raw: true) }

          let(:expected) do
            [["Initial Humanized Value",    0, "init"],
             ["Additional Humanized Value", 1, "addl"]]
          end

          it "includes the database integer in each item" do
            is_expected.to eq(expected)
          end
        end

        describe "with a variation keyword argument" do
          subject { described_class.send(:"human_#{plural}", variation: :short) }

          let(:expected) do
            [["Compact Initial",  "init"],
             ["Short Additional", "addl"]]
          end

          it "includes the database integer in each item" do
            is_expected.to eq(expected)
          end
        end
      end

      describe "self#human_#{single}" do
        context "default behavior" do
          subject { described_class.send(:"human_#{single}", "init") }

          it "translates the attribute" do
            is_expected.to eq("Initial Humanized Value")
          end
        end

        context "with a variation keyword argument" do
          subject { described_class.send(:"human_#{single}", "init", variation: :short) }

          it "translates the attribute with the given variation" do
            is_expected.to eq("Compact Initial")
          end
        end
      end

      describe "self#human_#{single}_order_clause" do
        context "default behavior" do
          subject { described_class.send(:"human_#{single}_order_clause") }

          let(:expected) { "CASE WHEN #{single}=1 THEN 0 WHEN #{single}=0 THEN 1 END" }

          it "returns a SQL order clause that sorts by humanized values" do
            is_expected.to eq(expected)
          end
        end

        context "with a variation keyword argument" do
          subject { described_class.send(:"human_#{single}_order_clause", variation: :short) }

          let(:expected) { "CASE WHEN #{single}=0 THEN 0 WHEN #{single}=1 THEN 1 END" }

          it "returns a SQL order clause that sorts by humanized variation" do
            is_expected.to eq(expected)
          end
        end
      end

      describe "self#sorted_by_human_#{single}" do
        subject { described_class }

        context "default behavior" do
          let(:expected) { "CASE WHEN #{single}=1 THEN 0 WHEN #{single}=0 THEN 1 END" }

          it "orders by humanized values" do
            expect(described_class).to receive(:order).with(expected).and_call_original

            actual = described_class.send(:"sorted_by_human_#{single}")

            expect(actual).to be_a_kind_of(ActiveRecord::Relation)
          end
        end

        context "with a variation keyword argument" do
          let(:expected) { "CASE WHEN #{single}=0 THEN 0 WHEN #{single}=1 THEN 1 END" }

          it "orders by humanized variation" do
            expect(described_class).to receive(:order).with(expected).and_call_original

            actual = described_class.send(:"sorted_by_human_#{single}", variation: :short)

            expect(actual).to be_a_kind_of(ActiveRecord::Relation)
          end
        end
      end
    end

    describe "at the instance level" do
      let(:instance) { create_minimal_instance }

      before(:each) { allow(instance).to receive(single).and_return("addl") }

      describe "#human_#{single}" do
        context "default behavior" do
          subject { instance.send(:"human_#{single}") }

          it "translates the attribute" do
            is_expected.to eq("Additional Humanized Value")
          end
        end

        context "with a variation keyword argument" do
          subject { instance.send(:"human_#{single}", variation: :short) }

          it "translates the attribute with the given variation" do
            is_expected.to eq("Short Additional")
          end
        end
      end

      describe "#raw_#{single}" do
        let(:instance) { create_minimal_instance }

        subject { instance.send(:"raw_#{single}") }

        it "returns raw integer value" do
          is_expected.to be_a_kind_of(Integer)
        end
      end
    end
  end
end
