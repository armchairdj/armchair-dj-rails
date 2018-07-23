# frozen_string_literal: true

class PostScoper < Ginsu::Scoper
  def allowed
    super.reverse_merge({
      "Draft"      => :draft,
      "Scheduled"  => :scheduled,
      "Published"  => :published
    })
  end
end
