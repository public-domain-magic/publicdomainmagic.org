# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR manifestation attribute "form of carrier": the kind of thing that
# carries the content (volume, print, PDF, online resource). Distinct from
# physical medium (paper, vellum), which is a separate attribute.
class Catalog::Carrier < ApplicationRecord
  has_many :manifestations
end
