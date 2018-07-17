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

    describe "nilify_blanks" do
      subject { create_minimal_instance }

      describe "nilify_blanks" do
        it { is_expected.to nilify_blanks(before: :validation) }
      end
    end
  end

  describe "scope-related" do
    describe "basics" do
      let!(    :first) { create(:minimal_role, name: "First" ) }
      let!(   :middle) { create(:minimal_role, name: "Middle") }
      let!(     :last) { create(:minimal_role, name: "Last"  ) }
      let(       :ids) { [first, middle, last].map(&:id) }
      let(:collection) { described_class.where(id: ids) }

      describe "self#for_show" do
        subject { collection.for_show }

        it { is_expected.to eager_load(:contributions, :works) }
      end

      pending "self#for_list"
    end
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
