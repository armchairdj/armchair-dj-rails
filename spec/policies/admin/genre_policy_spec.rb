# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::GenrePolicy do
  it_behaves_like "an_admin_policy" do
    let(:record) { create(:minimal_genre) }
  end

  pending "scope"
end
