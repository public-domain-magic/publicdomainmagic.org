# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# A third-party record *about* the work a librarian cites on the discovery form
# — a Conjuring Archive or Magicpedia entry, a dealer page. It becomes a
# +Catalog::ExternalReference+ (evidence and an existence attestation), not a
# Catalog edition.
class Discovery::ExternalReference
  include ActiveModel::API

  # The location (URL) of the record about the work.
  attr_accessor :url

  # Who holds the record (e.g. "Conjuring Archive").
  attr_accessor :source

  # A free-text note about what the record attests.
  attr_accessor :note

  validates :url, presence: true
end
