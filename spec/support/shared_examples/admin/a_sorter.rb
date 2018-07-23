# frozen_string_literal: true

RSpec.shared_examples "a_sorter" do
  let(:view_path) { model_class.model_name.plural }

  allowed_keys   = described_class.new.allowed.keys
  allowed_values = described_class.new.allowed.values
  resolved_map   = described_class.new.map

  describe "#constructor" do
    context "defaults" do
      let(:instance) { described_class.new(current_scope: "", current_sort: "", current_dir: "") }

      describe "sets current_scope to nil" do
        subject { instance.current_scope }

        it { is_expected.to eq(nil) }
      end

      describe "sets current_sort to default" do
        subject { instance.current_sort }

        it { is_expected.to eq(instance.allowed.keys.first) }
      end

      describe "sets current_dir to default" do
        subject { instance.current_dir }

        it { is_expected.to eq("ASC") }
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

      before(:each) do
        allow(instance).to receive(:reverse_first_clause).and_call_original
      end

      context "basics" do
        before(:each) do
          allow( instance).to receive(:validate)
          expect(instance).to receive(:validate)
        end

        it "validates" do
          is_expected.to be_a_kind_of(String)
        end
      end

      allowed_keys.each do |key|
        describe "for #{key} scope" do
          describe "with dir=ASC" do
            let(:instance) { described_class.new(current_sort: key, current_dir: "ASC") }

            before(:each) { expect(instance).to_not receive(:reverse_first_clause) }

            it "returns a sort clause" do
              is_expected.to be_a_kind_of(String)
            end
          end

          describe "with dir=DESC" do
            let(:instance) { described_class.new(current_sort: key, current_dir: "DESC") }

            before(:each) { expect(instance).to receive(:reverse_first_clause) }

            it "returns a sort clause" do
              is_expected.to be_a_kind_of(String)
            end
          end
        end
      end
    end

    describe "#map" do
      it "is a hash of hashes for use by the view" do
        expect(resolved_map).to be_a_kind_of(Hash)
      end

      resolved_map.each do |key, value|
        describe "key #{key}" do
          it { expect(value).to be_a_kind_of(Hash) }

          describe ":desc?" do
            it { expect(value[:desc?]).to be_boolean }
          end

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
      allowed_keys.each do |key|
        describe "key '#{key}' is a short string identifier for use in UI and querystring" do
          specify { expect(key).to be_a_kind_of(String) }
        end
      end

      allowed_values.each.with_index do |value, i|
        describe "value for '#{allowed_keys[i]}'" do
          it "is a sql string or an array of sql strings" do
            actual = [value].flatten

            actual.each { |str| expect(str).to be_a_kind_of(String) }
          end
        end
      end
    end

    context "private" do
      describe "#validate" do
        subject { instance.send(:validate) }

        describe "valid" do
          allowed_keys.each do |key|
            describe "for #{key} scope" do
              describe "and dir=ASC" do
                let(:instance) { described_class.new(current_sort: key, current_dir: "ASC") }

                specify { expect{ subject }.to_not raise_exception }
              end

              describe "and dir=DESC" do
                let(:instance) { described_class.new(current_sort: key, current_dir: "DESC") }

                specify { expect{ subject }.to_not raise_exception }
              end
            end
          end
        end

        describe "invalid" do
          context "sort" do
            let(:instance) { described_class.new(current_sort: "NOT_A_VALID_SORT_KEY") }

            specify { expect{ subject }.to raise_exception(Pundit::NotAuthorizedError) }
          end

          context "dir" do
            let(:instance) { described_class.new(current_dir: "NOT_A_VALID_DIR") }

            specify { expect{ subject }.to raise_exception(Pundit::NotAuthorizedError) }
          end
        end
      end
    end
  end
end
