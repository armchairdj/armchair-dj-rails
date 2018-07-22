# frozen_string_literal: true

class PostScoper < Scoper
  def allowed
    super.reverse_merge({
      "Draft"      => :draft,
      "Scheduled"  => :scheduled,
      "Published"  => :published
    })
  end
end
