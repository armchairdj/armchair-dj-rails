# frozen_string_literal: true

RSpec.shared_examples "a_scoper" do |model_class|
  let(:view_path) { model_class.model_name.plural }

  allowed_keys   = described_class.new.allowed.keys
  allowed_values = described_class.new.allowed.values
  resolved_map   = described_class.new.map

  describe "#constructor" do
    context "defaults" do
      let(:instance) { described_class.new(current_scope: "", current_sort: "", current_dir: "") }

      describe "sets current_scope to default" do
        subject { instance.current_scope }

        it { is_expected.to eq(instance.allowed.keys.first) }
      end

      describe "sets current_sort to nil" do
        subject { instance.current_sort }

        it { is_expected.to eq(nil) }
      end

      describe "sets current_dir to nil" do
        subject { instance.current_dir }

        it { is_expected.to eq(nil) }
      end
    end

    context "explicit values" do
      let(:instance) { described_class.new(current_scope: "All", current_sort: "ID", current_dir: "DESC") }

      describe "sets current_scope" do
        subject { instance.current_scope }

        it { is_expected.to eq("All") }
      end

      describe "sets current_sort" do
        subject { instance.current_sort }

        it { is_expected.to eq("ID") }
      end

      describe "sets current_dir" do
        subject { instance.current_dir }

        it { is_expected.to eq("DESC") }
      end
    end
  end

  describe "instance" do
    let(:current_scope) { "All"     }
    let(:current_sort ) { "Default" }
    let(:current_dir  ) { "ASC"     }
    let(:instance     ) { described_class.new(
      current_scope: current_scope,
      current_sort:  current_sort,
      current_dir:   current_dir
    ) }

    describe "#resolve" do
      subject { instance.resolve }

      context "basics" do
        before(:each) do
          allow( instance).to receive(:validate)
          expect(instance).to receive(:validate)
        end

        it "validates" do
          is_expected.to eq(instance.allowed[current_scope])
        end
      end

      allowed_keys.each do |key|
        context "for #{key} scope" do
          let(:instance) { described_class.new(current_scope: key) }

          it "returns a scope" do
            is_expected.to eq(instance.allowed[key])
          end
        end
      end
    end

    describe "#map" do
      it "is a hash of hashes for use by the view" do
        expect(resolved_map).to be_a_kind_of(Hash)
      end

      resolved_map.each do |key, value|
        context "for key #{key}" do
          it { expect(value).to be_a_kind_of(Hash) }

          describe ":active?" do
            it { expect(value[:active?]).to be_boolean }
          end

          describe ":url" do
            it { expect(value[:url]).to match(/\/admin\/\w+\?.+=.+(&.+=.+)*/) }
          end
        end
      end
    end

    describe "#allowed" do
      describe "keys" do
        allowed_keys.each do |key|
          describe "'#{key}' is a short string identifier for use in UI and querystring" do
            specify { expect(key).to be_a_kind_of(String) }
          end
        end
      end

      describe "values" do
        allowed_values.each.with_index do |value, i|
          describe "for '#{allowed_keys[i]}'" do
            it "is a symbolized model scope" do
              expect(value).to be_a_kind_of(Symbol)
            end

            it "can be called on the model" do
              actual = model_class.public_send(value)

              expect(actual).to be_a_kind_of(ActiveRecord::Relation)
            end
          end
        end
      end
    end

    context "private" do
      describe "#validate" do
        subject { instance.send(:validate) }

        describe "valid" do
          allowed_keys.each do |key|
            context "for #{key} scope" do
              let(:instance) { described_class.new(current_scope: key) }

              specify { expect{ subject }.to_not raise_exception }
            end
          end
        end

        describe "invalid" do
          let(:instance) { described_class.new(current_scope: "NOT_A_VALID_SCOPE_KEY") }

          specify { expect{ subject }.to raise_exception(Pundit::NotAuthorizedError) }
        end
      end
    end
  end
end
