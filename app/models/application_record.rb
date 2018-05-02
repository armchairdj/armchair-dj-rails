# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  nilify_blanks before: :validation

  include AtomicallyValidatable
  include Enumable

  def self.admin_scopes
    { "All" => :for_admin }
  end

  def self.default_admin_scope
    self.admin_scopes.values.first
  end
end
