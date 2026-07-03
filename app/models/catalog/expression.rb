# FRBR (WEMI): the intellectual or artistic realization of a work
class Catalog::Expression < ApplicationRecord
  belongs_to :form_of_expression
  belongs_to :language
  belongs_to :work
end
