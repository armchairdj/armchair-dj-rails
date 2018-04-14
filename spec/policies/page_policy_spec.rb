require 'rails_helper'

RSpec.describe PagePolicy do
  let(:user  ) { nil }
  let(:record) { true }

  subject { described_class.new(user, record) }

  specify { is_expected.to permit_action(:show) }
end
