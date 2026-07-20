# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The US copyright status answer for one copyrightable unit, including the
# public-domain countdown for works still under term.
#
# FRBR's work and the U.S. Copyright Office's "work" are false friends: the
# Office's unit of authorship is much closer to a specific published edition,
# so one FRBR work-family can hold many USCO works (Scot's 1584 text is public
# domain while a 1930 scholarly introduction is not). A determination therefore
# anchors to a Catalog work plus an optional manifestation scope: +nil+ means
# "the original text as first published" (the common case, and what the
# countdown feature reads); present means "the identified edition's added
# authorship", with its own clock.
#
# +public_domain_on+ may be in the future — even a book published tomorrow can
# be tracked with a 95-year countdown (see {TermExpiration}).
class Copyright::Determination < ApplicationRecord
  # The statutory grounds on which a work may be determined public domain.
  # This context speaks 17 U.S.C.; Project Gutenberg's rule numbers are an
  # operational shorthand translated at the seam via PG_RULES.
  BASES = %w[
    term_expired
    nonrenewal
    lack_of_notice
    us_government_work
    unrestored_foreign
    life_plus_seventy
    corporate_term
    pre_1978_unpublished
  ].freeze

  # Translation from statutory bases to Project Gutenberg's operational rule
  # numbers, used only where we speak PG's dialect (clearance submissions).
  PG_RULES = {
    "term_expired" => "1",
    "life_plus_seventy" => "2",
    "corporate_term" => "3",
    "pre_1978_unpublished" => "4",
    "lack_of_notice" => "5",
    "nonrenewal" => "6",
    "us_government_work" => "8",
    "unrestored_foreign" => "10",
  }.freeze

  # How far the research has gone. "Failure isn't a thing — it's just how far
  # it goes": there is no dead-end state, only a determination not yet made.
  STATUSES = %w[unknown researching determined].freeze

  belongs_to :work, class_name: "Catalog::Work"
  belongs_to :manifestation, class_name: "Catalog::Manifestation", optional: true

  has_many :investigations, dependent: :destroy
  has_many :clearances, dependent: :nullify

  enum :status, STATUSES.index_by(&:itself), validate: true
  enum :basis, BASES.index_by(&:itself), validate: { allow_nil: true }

  # Rails compares a nil scope with IS NULL, so this also enforces one
  # unscoped determination per work; the partial unique index backs it at the
  # DB layer (SQLite treats NULLs as distinct in ordinary unique indexes).
  validates :work_id, uniqueness: { scope: :manifestation_id }

  # The number of days until the work enters the public domain — the
  # countdown. +nil+ unless +public_domain_on+ is known and still in the
  # future.
  def countdown_days
    date = public_domain_on
    return nil if date.nil? || !date.future?

    (date.mjd - Date.current.mjd).to_i
  end

  # Project Gutenberg's rule number for this determination's statutory basis,
  # or +nil+ when no basis has been determined.
  def pg_rule
    PG_RULES[basis.to_s]
  end

  # Whether the work has entered the US public domain: a known
  # +public_domain_on+ date that has arrived. True on the date itself —
  # Public Domain Day is January 1, not January 2.
  def public_domain?
    date = public_domain_on
    !date.nil? && !date.future?
  end
end
