# frozen_string_literal: true

class CreatorScoper < Ginsu::Scoper
  def allowed
    super.reverse_merge({
      "Real"       => :primary,
      "Pseudynym"  => :secondary,
      "Individual" => :individual,
      "Group"      => :collective,
    })
  end

private

  def model_class
    Creator
  end
end
