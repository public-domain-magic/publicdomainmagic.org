module Copyright
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
