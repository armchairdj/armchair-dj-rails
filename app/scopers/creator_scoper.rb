# frozen_string_literal: true

class CreatorScoper < Ginsu::Scoper
  def allowed
    super.reverse_merge(
      "Primary"    => :primary,
      "Secondary"  => :secondary,
      "Individual" => :individual,
      "Group"      => :collective
    )
  end

private

  def model_class
    Creator
  end
end
