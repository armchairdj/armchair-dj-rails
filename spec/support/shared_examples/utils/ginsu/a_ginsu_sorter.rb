# frozen_string_literal: true

RSpec.shared_examples "a_ginsu_sorter" do
  let(:model_class) { described_class.new.send(:model_class) }
  let(:view_path) { model_class.model_name.plural }

  allowed_hash = described_class.new.allowed

  describe "instance" do
    let(:current_scope) { "All" }
    let(:current_sort) { "Default" }
    let(:current_dir) { "ASC" }

    let(:instance) do
      described_class.new(
        current_scope: current_scope,
        current_sort:  current_sort,
        current_dir:   current_dir
      )
    end

    describe "#resolved" do
      subject { instance.resolved }

      before do
        allow(described_class).to receive(:reverse_clause).and_call_original
      end

      it "validates" do
        expect(instance).to receive(:validate)

        is_expected.to be_a_kind_of(String)
      end

      allowed_hash.keys.each do |key|
        context "with #{key} scope and dir=ASC" do
          let(:instance) { described_class.new(current_sort: key, current_dir: "ASC") }

          before { expect(described_class).to_not receive(:reverse_clause) }

          it "returns a sort clause" do
            is_expected.to be_a_kind_of(String)
          end
        end

        context "with #{key} scope and dir=DESC" do
          let(:instance) { described_class.new(current_sort: key, current_dir: "DESC") }

          before { expect(described_class).to receive(:reverse_clause) }

          it "returns a sort clause" do
            is_expected.to be_a_kind_of(String)
          end
        end
      end
    end

    describe "#map" do
      let(:mapped) { described_class.new.map }

      it "returns a hash of hashes for use by the view" do
        expect(mapped).to be_a_kind_of(Hash)
      end

      describe "individual items" do
        described_class.new.map.each do |key, value|
          context "with key #{key}" do
            it { expect(value).to be_a_kind_of(Hash) }

            describe ":active?" do
              it { expect(value[:active?]).to be_boolean }
            end

            describe ":desc?" do
              it { expect(value[:desc?]).to be_boolean }
            end

            describe ":url" do
              it { expect(value[:url]).to match(%r{/admin/\w+\?.+=.+(&.+=.+)*}) }
            end
          end
        end
      end

      describe "active items" do
        subject { mapped.to_a.map(&:last).map { |x| x[:active?] }.delete_if { |x| x == false } }

        it { is_expected.to have(1).item }
      end

      describe "descending items" do
        subject { mapped.to_a.map(&:last).map { |x| x[:desc?] }.delete_if { |x| x == false } }

        context "when current_dir is ASC" do
          let(:mapped) { described_class.new(current_dir: "ASC").map }

          it { is_expected.to have(0).item }
        end

        context "when current_dir is DESC" do
          let(:mapped) { described_class.new(current_dir: "DESC").map }

          it { is_expected.to have(1).items }
        end
      end
    end

    describe "#allowed" do
      allowed_hash.keys.each do |key|
        describe "key '#{key}' is a short string identifier for use in UI and querystring" do
          specify { expect(key).to be_a_kind_of(String) }
        end
      end

      allowed_hash.each do |key, value|
        describe "value for '#{key}'" do
          it "is a sql string or an array of sql strings" do
            actual = [*value]

            expect(actual).to all(be_a_kind_of(String))
          end
        end
      end
    end

    describe "#validate" do
      subject { instance.send(:validate) }

      describe "valid" do
        allowed_hash.keys.each do |key|
          describe "for #{key} scope" do
            describe "and dir=ASC" do
              let(:instance) { described_class.new(current_sort: key, current_dir: "ASC") }

              specify { expect { subject }.to_not raise_exception }
            end

            describe "and dir=DESC" do
              let(:instance) { described_class.new(current_sort: key, current_dir: "DESC") }

              specify { expect { subject }.to_not raise_exception }
            end
          end
        end
      end

      context "with an invalid sort" do
        let(:instance) { described_class.new(current_sort: "NOT_A_VALID_SORT_KEY") }

        specify { expect { subject }.to raise_exception(Pundit::NotAuthorizedError) }
      end

      context "with an invalid dir" do
        let(:instance) { described_class.new(current_dir: "NOT_A_VALID_DIR") }

        specify { expect { subject }.to raise_exception(Pundit::NotAuthorizedError) }
      end
    end
  end
end
