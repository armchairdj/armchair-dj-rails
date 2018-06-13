# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_sluggable_model" do
  let(:instance) { create_minimal_instance }

  context "included" do
    pending "includes friendly_id"
    pending "#normalize_friendly_id"
    pending "#slug_candidates"
    pending "#base_slug"
    pending "#sequenced_slug"
    pending "#generate_slug_from_parts"
    pending "#sluggable_parts"

    describe "generates new slug" do
      describe "#clear_slug?" do
        context "false" do
          subject { build_minimal_instance.clear_slug? }

          it { is_expected.to eq(false) }
        end

        context "true" do
          subject { build_minimal_instance(clear_slug: true).clear_slug? }

          it { is_expected.to eq(true) }
        end
      end

      describe "#handle_cleared_slug" do
        before(:each) do
          allow(subject).to receive(:slug_candidates).and_call_original
        end

        context "false" do
          subject { create_minimal_instance }

          before(:each) { expect(subject).to_not receive(:slug_candidates) }

          it { subject.save }
        end

        context "true" do
          subject do
            instance            = create_minimal_instance
            instance.clear_slug = "1"
            instance
          end

          before(:each) do
            expect(subject).to receive(:slug_candidates)
          end

          it { subject.save }
        end
      end
    end
  end
end
