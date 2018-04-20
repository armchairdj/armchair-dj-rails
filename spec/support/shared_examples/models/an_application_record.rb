require "rails_helper"

RSpec.shared_examples "an application record" do
  context "included" do
    describe "nilify_blanks" do
      pending "runs before validation"
    end
  end

  context "class" do
    describe "default_admin_scope" do
      subject { described_class.default_admin_scope }

      specify { expect(subject).to be_a_kind_of(Symbol) }

      specify { expect(subject).to eq(described_class.admin_scopes.values.first) }

      specify { expect(described_class.respond_to?(subject)).to eq(true) }
    end

    describe "admin_scopes" do
      subject { described_class.admin_scopes }

      specify { expect(subject).to be_a_kind_of(Hash) }

      specify "keys are strings" do
        subject.keys.each do |sym|
          expect(sym).to be_a_kind_of(String)
        end
      end

      specify "values are symbols of scopes" do
        described_class.admin_scopes.values.each do |sym|
          expect(sym).to be_a_kind_of(Symbol)

          expect(described_class.respond_to?(sym)).to eq(true)
        end
      end
    end
  end

  context "instance" do
    # Nothing so far.
  end

  context "concerns" do
    # Concerns are tested in the models that actually use them.
  end
end
