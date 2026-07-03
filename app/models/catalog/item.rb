# FRBR (WEMI): One example or exemplar of a manifestation is called an item.
# Usually it is a single object, but sometimes
# it comprises more than one physical object.
# An Item identifies individual copies of a
# Manifestation and describes its unique attributes.
class Catalog::Item < ApplicationRecord
  belongs_to :manifestation
  belongs_to :condition
end
