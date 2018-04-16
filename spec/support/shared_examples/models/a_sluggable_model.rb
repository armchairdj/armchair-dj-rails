require "rails_helper"

RSpec.shared_examples 'a sluggable model' do |attribute|
  let(:instance) { build_minimal_instance }

  describe 'class' do
    describe 'self#generate_slug_part' do
      pending 'replaces &'
      pending 'replaces punctuation'
      pending 'replaces whitespace'
      pending 'replaces non-word characters'
      pending 'replaces trailing underscore'
      pending 'collapses underscores'
      pending 'leaves non-ASCII word characters'
    end

    describe 'self#generate_slug' do
      describe 'one part' do
        pending 'generates part'
      end

      describe 'multiple parts' do
        pending 'generates parts and separates with slash'
      end
    end
  end

  describe 'included' do
    it { should validate_uniqueness_of(:slug) }
  end

  describe 'instance' do
    describe '#slugify' do
      pending 'sets unique slug for attribute with one part'
      pending 'sets unique slug for attribute with multiple parts'
      pending 'does nothing if no parts'
    end

    describe '#generate_unique_slug' do
      pending 'adds index for non-unique slug'
    end

    describe '#find_duplicate_slug' do
      pending 'finds max similar slug in database'
    end

    describe '#next_slug_index' do
      pending 'increments no index to 1'
      pending 'increments existing index by 1'
    end
  end
end
