# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ReviewPolicy do
  it_behaves_like "an_admin_publishable_policy"
end
