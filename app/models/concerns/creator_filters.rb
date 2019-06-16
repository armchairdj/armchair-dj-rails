# frozen_string_literal: true

concern :CreatorFilters do
  included do
    scope :by_creator, lambda { |*creators|
      by_association(creators, :creators)
    }

    scope :by_maker, lambda { |*makers|
      by_association(makers, :makers, table_name: :creators)
    }

    scope :by_contributor, lambda { |*contributors|
      by_association(contributors, :contributors, table_name: :creators)
    }
  end
end
