# FRBR (WEMI): a distinct intellectual or artistic creation.
class Catalog::Work < ApplicationRecord
  belongs_to :form_of_work
end
