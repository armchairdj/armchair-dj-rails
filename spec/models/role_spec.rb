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

RSpec.describe Role, type: :model do
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_eager_loadable_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:contributions, :works] }
    end

    describe "nilify_blanks" do
      subject { create_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    # Nothing so far.
  end

  describe "associations" do
    it { is_expected.to have_many(:contributions) }

    it { is_expected.to have_many(:works).through(:contributions) }
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:medium) }
    it { is_expected.to validate_inclusion_of(:medium).in_array(Work.valid_media) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:medium) }
  end

  describe "instance" do
    let(:instance) { create_minimal_instance }

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.display_medium, instance.name]) }
    end

    describe "#display_name" do
      describe "basic" do
        subject { instance.display_name }

        it { is_expected.to eq(instance.name) }
      end

      describe "full" do
        subject { instance.display_name(full: true) }

        it { is_expected.to eq("#{instance.display_medium}: #{instance.name}") }
      end
    end

    describe "#display_medium" do
      describe "basic" do
        subject { create_minimal_instance(medium: "TvEpisode").display_medium }

        it { is_expected.to eq("TV Episode") }
      end
    end
  end
end
