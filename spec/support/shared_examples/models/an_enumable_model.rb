# frozen_string_literal: true

RSpec.shared_examples "an_enumable_model" do |attributes|
  let(:instance) { create_minimal_instance }

  describe "class" do
    subject { described_class }

    it { is_expected.to respond_to(:human_enum_collection) }

    it { is_expected.to respond_to(:human_enum_collection_with_keys) }

    it { is_expected.to respond_to(:human_enum_value) }

    it { is_expected.to respond_to(:enumable_attributes) }

    it { is_expected.to respond_to(:alpha_order_clause_for) }

    specify { expect(described_class.retrieve_enumable_attributes).to match_array(attributes) }
  end

  attributes.each do |attribute|
    single_attr = attribute.to_s
    plural_attr = single_attr.pluralize
    i18n_key    = "activerecord.attributes.#{described_class.model_name.i18n_key}.#{plural_attr}"

    it { is_expected.to define_enum_for(attribute) }

    describe "i18n for #{single_attr}" do
      describe "singular" do
        described_class.send(plural_attr).keys.each do |val|
          it "has a localized string for #{val}" do
            expect(described_class.send(:"human_#{single_attr}", val)).to_not match(/translation missing/i)
          end
        end
      end
    end

    describe "for #{single_attr}" do
      describe "class" do
        describe "basic behavior" do
          before(:each) do
            allow(described_class).to receive(plural_attr).and_return({
              "b" => 0,
              "a" => 1,
              "r" => 2
            })

            allow(I18n).to receive(:t).and_call_original

            allow(I18n).to receive(:t).with("#{i18n_key}.b").and_return("Z.")
            allow(I18n).to receive(:t).with("#{i18n_key}.a").and_return("Y.")
            allow(I18n).to receive(:t).with("#{i18n_key}.r").and_return("X.")
          end

          describe "self#human_#{plural_attr}" do
            subject { described_class.send(:"human_#{plural_attr}") }

            it "gives a 2D array mapping humanized values to enum values for use in dropdowns" do
              is_expected.to eq([["Z.", "b"], ["Y.", "a"], ["X.", "r"]])
            end
          end

          describe "self#human_#{plural_attr}_with_keys" do
            subject { described_class.send(:"human_#{plural_attr}_with_keys") }

            it "gives a 2D array mapping humanized values to enum values for use in dropdowns" do
              is_expected.to eq([["Z.", "b", 0], ["Y.", "a", 1], ["X.", "r", 2]])
            end
          end

          describe "self#human_#{single_attr}" do
            subject { described_class.send(:"human_#{single_attr}", "b") }

            it "accepts an enum string identifier and returns the humanized i18n value" do
              is_expected.to eq("Z.")
            end
          end

          describe "self#alpha_order_clause_for" do
            subject { described_class.send(:alpha_order_clause_for, single_attr) }

            it "returns a SQL order clause that sorts by humanized values" do
              expected = "CASE WHEN #{single_attr}=2 THEN 0 WHEN #{single_attr}=1 THEN 1 WHEN #{single_attr}=0 THEN 2 END"

              is_expected.to eq(expected)
            end
          end
        end

        describe "translations" do
          specify "are not missing" do
            described_class.send(:"human_#{plural_attr}").each do |translation|
              expect(translation.first).to_not match(/translation missing/)
            end
          end
        end
      end

      describe "instance" do
        describe "#human_#{single_attr}" do
          it "calls class method" do
             allow(described_class).to receive("human_#{single_attr}")
            expect(described_class).to receive("human_#{single_attr}").with(instance.send(:"#{single_attr}"))

            instance.send(:"human_#{single_attr}")
          end
        end

        describe "#raw_#{single_attr}" do
          let(:instance) { create_minimal_instance }

          subject { instance.send(:"raw_#{single_attr}") }

          it "returns integer value" do
            is_expected.to be_a_kind_of(Integer)
          end

          it "returns the correct integer" do
            allow(instance).to receive(:"#{single_attr}").and_return("a")
            allow(described_class).to receive(plural_attr).and_return({
              "b" => 0,
              "a" => 1,
              "r" => 2
            })

            is_expected.to eq(1)
          end
        end
      end
    end
  end
end
