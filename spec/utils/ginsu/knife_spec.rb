# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ginsu::Knife do
  describe "instance" do
    context "class" do
      describe "#diced_url" do
        subject { described_class.send(:diced_url, Article, scope, sort, dir) }

        context "with all params" do
          let(:scope) { "scope" }
          let(:sort) { "sort" }
          let(:dir) { "dir"   }

          it { is_expected.to eq("/admin/articles?dir=dir&scope=scope&sort=sort") }
        end

        context "with missing sort params" do
          let(:scope) { "scope" }
          let(:sort) { nil }
          let(:dir) { nil     }

          it { is_expected.to eq("/admin/articles?scope=scope") }
        end

        context "with missing scope params" do
          let(:scope) { nil }
          let(:sort) { "sort" }
          let(:dir) { "dir" }

          it { is_expected.to eq("/admin/articles?dir=dir&sort=sort") }
        end
      end
    end
  end
end
