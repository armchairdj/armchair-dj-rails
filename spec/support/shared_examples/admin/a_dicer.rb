# frozen_string_literal: true

RSpec.shared_examples "a_dicer" do |model_class|
  let(:view_path) { model_class.model_name.plural }

  describe "instance" do
    let(:instance) { described_class.new }

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

        context "with missing sort params" do
          let(:scope) { "scope" }
          let( :sort) { nil     }
          let(  :dir) { nil     }

          it { is_expected.to eq("/admin/#{view_path}?scope=scope") }
        end

        context "with missing scope params" do
          let(:scope) { nil     }
          let( :sort) { "sort"  }
          let(  :dir) { "dir"   }

          it { is_expected.to eq("/admin/#{view_path}?dir=dir&sort=sort") }
        end
      end
    end
  end
end
