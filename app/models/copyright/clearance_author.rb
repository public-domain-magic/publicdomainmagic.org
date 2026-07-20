# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# One author row on a Project Gutenberg clearance form (at most
# {Copyright::Clearance::MAX_AUTHORS} per clearance). A PG-facing exchange
# object: the stored role is PG's literal option text so the submitted value
# is exactly what the form expects.
class Copyright::ClearanceAuthor < ApplicationRecord
  # PG's role vocabulary, keyed by snake_case label for clean predicates and
  # valued with the form's literal option text (verified against the live
  # form HTML).
  ROLES = {
    author_creator: "Author/Creator",
    editor: "Editor",
    translator: "Translator",
    illustrator: "Illustrator",
    compiler: "Compiler",
    annotator: "Annotator",
    commentator: "Commentator",
    performer: "Performer",
    photographer: "Photographer",
    engraver: "Engraver",
    artist: "Artist",
    contributor: "Contributor",
    unknown_role: "Unknown role",
  }.freeze

  belongs_to :clearance, inverse_of: :authors

  enum :role, ROLES, validate: true
end
