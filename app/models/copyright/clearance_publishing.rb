# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# One publishing row on a Project Gutenberg clearance form (at most
# {Copyright::Clearance::MAX_PUBLISHINGS} per clearance) — PG's name for a
# year/type pair describing a publication event of the book. A PG-facing
# exchange object: the stored kind is PG's literal option text.
class Copyright::ClearancePublishing < ApplicationRecord
  # PG's publishing-type vocabulary, keyed by snake_case label and valued with
  # the form's complete literal "Type" option text.
  KINDS = {
    copyright_notice: "Copyright notice or similar",
    no_copyright_notice: "No copyright notice (just publication date)",
    reprint_or_facsimile: "Reprint or facsimile",
  }.freeze

  belongs_to :clearance, inverse_of: :publishings

  enum :kind, KINDS, validate: true
end
