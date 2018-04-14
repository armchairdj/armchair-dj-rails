RSpec.shared_examples "a publicly viewable model" do
  let(:public_instance) { create(:"minimal_#{described_class.model_name.param_key}",
    :with_published_post
  ) }

  let(:non_public_instance) { create(:"minimal_#{described_class.model_name.param_key}",
    :with_draft_post
  ) }

  context "instance" do
    describe "#is_public?" do
      specify { expect(    public_instance.is_public?).to eq(true ) }
      specify { expect(non_public_instance.is_public?).to eq(false) }
    end

    describe "#published_posts" do
      specify { expect(    public_instance.published_posts.length).to eq(1) }
      specify { expect(non_public_instance.published_posts.length).to eq(0) }
    end
  end
end
