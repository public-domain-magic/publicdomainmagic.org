# FRBR (WEMI): the physical embodiment of an expression of a work.
# A manifestation represents all the physical
# objects that bear the same characteristics
# of intellectual content and physical form. In
# actuality, a manifestation is itself an
# abstract entity, but describes and represents
# physical entities, that is all the items that
# have the same content and carrier.
class Catalog::Manifestation < ApplicationRecord
  belongs_to :form_of_expression
  belongs_to :medium
  belongs_to :language
  belongs_to :series
  belongs_to :expression
end
