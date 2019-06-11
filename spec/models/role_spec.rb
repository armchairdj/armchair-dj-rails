# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  medium     :string           not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_roles_on_alpha   (alpha)
#  index_roles_on_medium  (medium)
#

require "rails_helper"

RSpec.describe Role do
  describe "ApplicationRecord" do
    it_behaves_like "an_application_record"

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe ":Alphabetization" do
    it_behaves_like "an_alphabetizable_model"

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.display_medium, instance.name]) }
    end
  end

  describe ":AttributionAssociations" do
    it { is_expected.to have_many(:attributions).dependent(:destroy) }
    it { is_expected.to have_many(:contributions).dependent(:destroy) }

    it { is_expected.to have_many(:works).through(:contributions) }
  end

  describe ":GinsuIntegration" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:contributions, :works] }
    end
  end

  describe ":MediumAssociation" do
    it { is_expected.to validate_presence_of(:medium) }
    it { is_expected.to validate_inclusion_of(:medium).in_array(Work.valid_media) }

    describe "#display_medium" do
      describe "basic" do
        subject { build_minimal_instance(medium: "TvEpisode").display_medium }

        it { is_expected.to eq("TV Episode") }
      end
    end

    pending ".for_medium"
  end

  describe ":NameAttribute" do
    describe "validations" do
      subject { create_minimal_instance }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:medium) }
    end

    describe "#display_name" do
      let(:instance) { build_minimal_instance }

      context "without arguments" do
        subject { instance.display_name }

        it { is_expected.to eq(instance.name) }
      end

      context "with full: true" do
        subject { instance.display_name(full: true) }

        it { is_expected.to eq("#{instance.display_medium}: #{instance.name}") }
      end
    end
  end
end
