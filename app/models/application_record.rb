class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include AtomicallyValidatable
  include Enumable
end
