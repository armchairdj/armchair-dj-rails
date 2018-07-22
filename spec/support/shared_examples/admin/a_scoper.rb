# frozen_string_literal: true

RSpec.shared_examples "a_scoper" do |model_class|
  let(:view_path) { model_class.model_name.plural }

  allowed_keys   = described_class.new.allowed.keys
  allowed_values = described_class.new.allowed.values
  resolved_map   = described_class.new.map

  describe "#constructor" do
    describe "defaults" do
      let(:instance) { described_class.new("", "", "") }

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

    describe "explicit values" do
      let(:instance) { described_class.new("All", "ID", "DESC") }

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
    let(:instance     ) { described_class.new(current_scope, current_sort, current_dir) }
    let(:current_scope) { "All"     }
    let(:current_sort ) { "Default" }
    let(:current_dir  ) { "ASC"     }

    describe "#resolve" do
      subject { instance.resolve }

      before(:each) do
        allow( instance).to receive(:validate)
        expect(instance).to receive(:validate)
      end
    end

    describe "#map" do
      it "is a hash of hashes for use by the view" do
        expect(resolved_map).to be_a_kind_of(Hash)
      end

      resolved_map.each do |key, value|
        describe "key #{key}" do
          it { expect(value          ).to be_a_kind_of(Hash) }
          it { expect(value[:active?]).to be_in([true, false]) }
          it { expect(value[:url    ]).to be_a_kind_of(String) }
        end
      end
    end

    describe "#allowed" do
      allowed_keys.each do |key|
        describe "key :#{key} is a short string identifier for use in UI and querystring" do
          specify { expect(key).to be_a_kind_of(String) }
        end
      end

      allowed_values.each do |value|
        describe "value #{value}" do
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

    context "private" do
      describe "#model_class" do
        subject { instance.send(:model_class) }

        it { is_expected.to eq(model_class) }
      end

      describe "#diced_url" do
        subject { instance.send(:diced_url, scope, sort, dir) }

        context "with all params" do
          let(:scope) { "scope" }
          let( :sort) { "sort"  }
          let(  :dir) { "dir"   }

          it { is_expected.to eq("/admin/#{view_path}?dir=dir&scope=scope&sort=sort") }
        end

        context "with missing params" do
          let(:scope) { "scope" }
          let( :sort) { nil     }
          let(  :dir) { nil     }

          it { is_expected.to eq("/admin/#{view_path}?scope=scope") }
        end
      end

      describe "#validate" do
        subject { instance.send(:validate) }

        describe "valid" do
          allowed_keys.each do |key|
            describe "for #{key} scope" do
              let(:instance) { described_class.new(key) }

              specify { expect{ subject }.to_not raise_exception }
            end
          end
        end

        describe "invalid" do
          let(:instance) { described_class.new("NOT_A_VALID_KEY") }

          specify { expect{ subject }.to raise_exception(Pundit::NotAuthorizedError) }
        end
      end
    end
  end
end
