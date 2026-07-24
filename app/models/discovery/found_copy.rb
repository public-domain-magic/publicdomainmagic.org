# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# One copy of a book a librarian found online, as entered on the discovery form.
# It becomes a Catalog edition: an online +Catalog::Manifestation+ (bearing the
# URL as its access address) embodied by an expression. Whether that is the
# work's existing expression or a new one turns on a content change, not on the
# medium — a faithful scan or re-keyed transcription is the same expression; a
# modernized or abridged text is a new one. The librarian makes that call.
class Discovery::FoundCopy
  include ActiveModel::API

  # The remote location (URL) the copy is read at — the manifestation's access
  # address.
  attr_accessor :url

  # Where it was found (e.g. "Internet Archive", "Project Gutenberg").
  attr_accessor :source

  # The byline as printed on this copy, preserved verbatim as the
  # manifestation's statement of responsibility (distinct from the work's
  # creator relationships).
  attr_accessor :statement_of_responsibility

  # +"new"+ when this copy's content was altered (modernized spelling,
  # abridgement, added apparatus) and so realizes a new expression; anything
  # else attaches it to the discovery's primary expression (content unchanged).
  attr_accessor :content

  # The id of an already-cataloged print edition this copy reproduces, when
  # known — records the +reproduction+ manifestation relationship.
  attr_accessor :reproduction_of_manifestation_id

  validates :url, presence: true

  # Whether this copy realizes a new expression rather than attaching to the
  # discovery's primary one.
  def new_expression? = content.to_s == "new"
end
