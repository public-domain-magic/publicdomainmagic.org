# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# A renewal registration a search turned up — including ones judged not to
# apply (+applies: false+, e.g. a renewal of a different work by the same
# author). PG requires reporting ALL records found, with the researcher's
# +assessment+ of applicability.
class Copyright::RenewalRecord < ApplicationRecord
  belongs_to :renewal_search

  has_many :citations, as: :citable, dependent: :destroy

  validates :renewal_number, presence: true
end
