# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ArticlePolicy do
  it_behaves_like "an_admin_post_policy"
end
