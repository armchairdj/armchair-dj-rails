# frozen_string_literal: true

class Scoper < Dicer
  def initialize(current_scope, current_sort, current_dir)
    current_scope = allowed.keys.first if current_scope.blank?
    current_sort  = nil                if current_sort.blank?
    current_dir   = nil                if current_dir.blank?

    super(current_scope, current_sort, current_dir)
  end

  def resolve
    ensure_valid

    allowed[@current_scope]
  end

  def map
    allowed.keys.each.inject({}) do |memo, (scope)|
      active = scope == @current_scope
      url    = diced_url(scope, @current_sort, @current_dir)

      memo[scope] = { :active? => active, :url => url }
      memo
    end
  end

  def allowed
    { "All" => :all }
  end

private

  def ensure_valid
    return if allowed.keys.include?(@current_scope)

    raise Pundit::NotAuthorizedError, "Unknown scope for #{model_class}: #{@current_scope}."
  end
end
