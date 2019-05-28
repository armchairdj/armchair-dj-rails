# frozen_string_literal: true

RSpec.shared_examples "a_ginsu_scoper" do
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

      context "basics" do
        before(:each) do
          expect(instance).to receive(:validate)
        end

        it "validates" do
          is_expected.to eq(instance.allowed[current_scope])
        end
      end

      allowed_hash.keys.each do |key|
        context "for #{key} scope" do
          let(:instance) { described_class.new(current_scope: key) }

          it "returns a scope" do
            is_expected.to eq(instance.allowed[key])
          end
        end
      end
    end

    describe "#map" do
      let(:mapped) { described_class.new.map }

      it "is a hash of hashes for use by the view" do
        expect(mapped).to be_a_kind_of(Hash)
      end

      describe "individual items" do
        described_class.new.map.each do |key, value|
          context "for key #{key}" do
            it { expect(value).to be_a_kind_of(Hash) }

            describe ":active?" do
              it { expect(value[:active?]).to be_boolean }
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
    end

    describe "#allowed" do
      describe "keys" do
        allowed_hash.keys.each do |key|
          describe "'#{key}' is a short string identifier for use in UI and querystring" do
            specify { expect(key).to be_a_kind_of(String) }
          end
        end
      end

      describe "values" do
        allowed_hash.each do |key, value|
          describe "for '#{key}'" do
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
          allowed_hash.keys.each do |key|
            context "for #{key} scope" do
              let(:instance) { described_class.new(current_scope: key) }

              specify { expect { subject }.to_not raise_exception }
            end
          end
        end

        describe "invalid" do
          let(:instance) { described_class.new(current_scope: "NOT_A_VALID_SCOPE_KEY") }

          specify { expect { subject }.to raise_exception(Pundit::NotAuthorizedError) }
        end
      end
    end
  end
end
