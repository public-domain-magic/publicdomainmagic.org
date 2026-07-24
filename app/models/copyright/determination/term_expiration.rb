# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The pre-1978 95-year publication term (17 U.S.C. § 304; Project Gutenberg's
# "Rule 1" at the seam): a work first published in the United States in year Y
# ≤ 1977 enters the public domain on January 1 of Y + 96.
#
# Term expiry settles the status *by itself* only once the full term has run:
# by then the maximal 95-year term has elapsed regardless of whether the
# copyright was ever renewed, so the outcome is certain. A pre-1978 work whose
# term has *not* yet run cannot be settled on term alone — renewal and notice
# decide it, which is the {Verdict}'s "needs Rule 6" band. The +expires_on+
# date is still computed for any year, so a countdown can be shown once a
# researcher establishes a future public-domain date.
class Copyright::Determination::TermExpiration
  # The last first-publication year the pre-1978 publication term covers.
  FINAL_YEAR = 1977

  # The term runs 95 full calendar years, so the work is public domain on
  # January 1 of the 96th year after publication (published 1930 → 2026-01-01).
  YEARS_UNTIL_EXPIRATION = 96

  # Takes the Copyright::Determination whose term is being computed.
  def initialize(determination)
    @determination = determination
  end

  # Whether the pre-1978 publication-term regime governs: a known
  # first-publication year of 1977 or earlier.
  def applicable?
    published_in = year
    !published_in.nil? && published_in <= FINAL_YEAR
  end

  # Whether the 95-year term has actually run as of today — the only case in
  # which term expiry alone settles the status, since the maximal term has
  # elapsed regardless of renewal. Advances on its own every January 1.
  def expired?
    date = expires_on
    !date.nil? && !date.future?
  end

  # Records the term expiration on the determination: basis +term_expired+,
  # status +determined+, and the computed +public_domain_on+ date. Returns
  # +false+ without touching the determination unless the term has run.
  def apply!
    return false unless expired?

    @determination.update!(
      basis: :term_expired, status: :determined, public_domain_on: expires_on)
    true
  end

  # The date the publication term expires: January 1 of the 96th year after
  # first publication, or +nil+ when no year is known.
  def expires_on
    published_in = year
    return nil if published_in.nil?

    Date.new(published_in + YEARS_UNTIL_EXPIRATION, 1, 1)
  end

  # The four-digit first-publication year, read from the determination's
  # EDTF-style +first_publication_year+; a range such as "1924/1928" counts
  # from its start. +nil+ when no year is recorded.
  def year
    @determination.first_publication_year.to_s[/\A\d{4}/]&.to_i
  end
end
