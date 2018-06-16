# frozen_string_literal: true

require "ffaker"

FactoryBot.define do
  factory :credit do

    ###########################################################################
    # TRAITS.
    ###########################################################################

    ###########################################################################
    # FACTORIES.
    ###########################################################################

    factory :minimal_credit, parent: :credit_with_creator do; end

    factory :credit_without_creator do
      with_work
    end

    factory :credit_with_creator do
      with_work
      with_creator
    end
  end
end
