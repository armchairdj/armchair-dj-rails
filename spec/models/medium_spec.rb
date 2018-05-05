require "rails_helper"

RSpec.describe Medium, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_summarizable_model"

    it_behaves_like "a_viewable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let!( :song_medium) { create(:medium, name: "Song" ) }
      let!(:album_medium) { create(:medium, name: "Album") }
      let!(:movie_medium) { create(:medium, name: "Movie") }

      let(:ids) { [song_medium, album_medium, movie_medium].map(&:id) }

      before(:each) do
        create(:review, :with_author, :with_body, :published,
          "work_attributes" => attributes_for(:minimal_work, medium: song_medium)
        )

        create(:review, :with_author, :with_body, :published,
          "work_attributes" => attributes_for(:minimal_work, medium: album_medium)
        )

        create(:review, :with_author, :with_body, :draft,
          "work_attributes" => attributes_for(:minimal_work, medium: movie_medium)
        )
      end

      describe "self#eager" do
        subject { described_class.eager }

        it { should eager_load(:roles, :works) }
      end

      describe "self#for_admin" do
        subject { described_class.for_admin.where(id: ids) }

        specify "includes all media, unsorted" do
          should match_array([song_medium, album_medium, movie_medium])
        end

        it { should eager_load(:roles, :works) }
      end

      describe "self#for_site" do
        subject { described_class.for_site.where(id: ids) }

        specify "includes only media with published posts, sorted alphabetically" do
          should eq([album_medium, song_medium])
        end

        it { should eager_load(:roles, :works) }
      end
    end
  end

  context "associations" do
    it { should have_many(:roles) }

    it { should have_many(:works) }

    it { should have_many(:creators).through(:works) }

    it { should have_many(:posts).through(:works) }
  end

  context "attributes" do
    context "nested" do
      # Nothing so far.
    end

    context "enums" do
      # Nothing so far.
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:name) }

    context "conditional" do
      # Nothing so far.
    end

    context "custom" do
      # Nothing so far.
    end
  end

  context "hooks" do
    # Nothing so far.

    context "callbacks" do
      # Nothing so far.
    end
  end

  context "instance" do
    pending "#alpha_parts"

    describe "private" do
      # Nothing so far.
    end
  end
end
