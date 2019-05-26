# frozen_string_literal: true

concern :Linkable do
  included do
    has_many :links, as: :linkable, dependent: :destroy

    accepts_nested_attributes_for(:links, allow_destroy: true,
                                          reject_if:     proc { |attrs| attrs["url"].blank? })
  end

  def prepare_links
    5.times { links.build }
  end
end
