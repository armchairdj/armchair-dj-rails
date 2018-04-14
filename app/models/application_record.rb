class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  nilify_blanks before: :validation

  include AtomicallyValidatable
  include Enumable

  def self.admin_scopes
    { 'All' => :all }
  end

  def self.default_admin_scope
    self.admin_scopes.values.first
  end
end
