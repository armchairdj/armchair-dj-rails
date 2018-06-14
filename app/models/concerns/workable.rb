# frozen_string_literal: true

module Workable
  extend ActiveSupport::Concern

  class_methods do
    def model_name
      Work.model_name
    end

    def true_model_name
      ActiveModel::Name.new(self.name.constantize)
    end
  end
end
