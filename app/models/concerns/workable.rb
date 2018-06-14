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

    def true_human_model_name
      I18n.t("activerecord.subclasses.work.#{true_model_name.i18n_key}")
    end
  end

  included do
    def true_model_name
      self.class.true_model_name
    end

    def true_human_model_name
      self.class.true_human_model_name
    end
  end
end
