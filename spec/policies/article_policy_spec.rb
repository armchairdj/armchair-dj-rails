# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArticlePolicy do
  it_behaves_like "a_public_policy"
  it_behaves_like "a_feedable_policy"
end
