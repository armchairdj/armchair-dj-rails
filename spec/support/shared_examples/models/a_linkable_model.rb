# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_linkable_model" do
  subject { create_minimal_instance }

  describe "included" do
    describe "associations" do
      it { is_expected.to have_many(:links).dependent(:destroy) }
    end

    describe "attributes" do
      describe "links" do
        it { is_expected.to accept_nested_attributes_for(:links).allow_destroy(true) }

        describe "#prepare_links" do
          it "builds 5 initially" do
            subject.prepare_links

            expect(subject.links).to have(5).items
          end

          it "builds 5 more" do
            subject.update!(links_attributes: {
              "0" => attributes_for(:minimal_link)
            })

            subject.prepare_links

            expect(subject.links).to have(6).items
          end
        end

        describe "reject_if" do
          subject { build_minimal_instance(links_attributes: { "0" => attributes_for(:minimal_link, url: "") }) }

          it "rejects link with blank url" do
            expect { subject.save! }.to_not change { Link.count }

            expect(subject.links).to eq([])
          end
        end
      end
    end
  end
end
