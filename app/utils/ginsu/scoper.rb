# frozen_string_literal: true

module Ginsu
  class Scoper < Knife
    ###########################################################################
    # INSTANCE.
    ###########################################################################

    def initialize(current_scope: nil, current_sort: nil, current_dir: nil)
      current_scope = allowed.keys.first if current_scope.blank?
      current_sort  = nil                if current_sort.blank?
      current_dir   = nil                if current_dir.blank?

      super(current_scope: current_scope, current_sort: current_sort, current_dir: current_dir)
    end

    def resolve
      validate

      allowed[@current_scope]
    end

    def map
      allowed.keys.each.inject({}) do |memo, (scope)|
        active = scope == @current_scope
        url    = diced_url(scope, @current_sort, @current_dir)

        memo[scope] = { active?: active, url: url }
        memo
      end
    end

    def allowed
      { "All" => :all }
    end

  private

    def valid?
      allowed.keys.include?(@current_scope)
    end

    def invalid_msg
      I18n.t("exceptions.scoper.invalid", model: model_class, scope: @current_scope)
    end
  end
end
