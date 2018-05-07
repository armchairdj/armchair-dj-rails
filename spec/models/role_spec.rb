require "rails_helper"

RSpec.describe Role, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"
  end

  context "class" do
    describe "self#grouped_options" do
      subject { described_class.grouped_options }

      let!(:z_medium) { create(:minimal_medium, name: "Z") }
      let!(:a_medium) { create(:minimal_medium, name: "A") }

      let!(:z_roles) { [] }
      let!(:a_roles) { [] }

      before(:each) do
        3.times do |i|
          z_roles << create(:minimal_role, medium: z_medium, name: "Z Role #{3 - i}")
          a_roles << create(:minimal_role, medium: a_medium, name: "A Role #{3 - i}")
        end
      end

      it "prepares alpha options for view, adding data-attributes for JS" do
        expected = [
          [ "A", [
            [ "A Role 1", a_roles[2].id, { :"data-grouping" => a_medium.id } ],
            [ "A Role 2", a_roles[1].id, { :"data-grouping" => a_medium.id } ],
            [ "A Role 3", a_roles[0].id, { :"data-grouping" => a_medium.id } ]
          ]],

          [ "Z", [
            [ "Z Role 1", z_roles[2].id, { :"data-grouping" => z_medium.id } ],
            [ "Z Role 2", z_roles[1].id, { :"data-grouping" => z_medium.id } ],
            [ "Z Role 3", z_roles[0].id, { :"data-grouping" => z_medium.id } ]
          ]],
        ]

        should eq expected
      end
    end
  end

  context "scope-related" do
    pending "self#eager"
    pending "self#for_admin"
  end

  context "associations" do
    it { should belong_to(:medium) }

    it { should have_many(:contributions) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:medium) }

    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:name).scoped_to(:medium_id) }
  end

  context "instance" do
    pending "#alpha_parts"

    describe "#display_name" do
      pending "basic"
      pending "full"
    end
  end
end
