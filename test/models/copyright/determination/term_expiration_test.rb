# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::Determination::TermExpirationTest < ActiveSupport::TestCase
  test "a 1930 publication enters the public domain on 2026-01-01" do
    determination = copyright_determinations(:trick_brain)
    determination.update!(first_publication_year: "1930")

    assert Copyright::Determination::TermExpiration.new(determination).apply!
    assert_equal "term_expired", determination.basis
    assert_equal "determined", determination.status
    assert_equal Date.new(2026, 1, 1), determination.public_domain_on
  end

  test "a 1948 publication enters the public domain on 2044-01-01" do
    determination = copyright_determinations(:trick_brain)
    determination.update!(first_publication_year: "1948")

    assert Copyright::Determination::TermExpiration.new(determination).apply!
    assert_equal Date.new(2044, 1, 1), determination.public_domain_on
  end

  test "an EDTF range counts from its start year" do
    determination = copyright_determinations(:trick_brain)
    determination.update!(first_publication_year: "1924/1928")

    term_expiration = Copyright::Determination::TermExpiration.new(determination)
    assert_predicate term_expiration, :applicable?
    assert_equal Date.new(2020, 1, 1), term_expiration.expires_on
  end

  test "the term covers first publication through 1977" do
    determination = copyright_determinations(:trick_brain)
    determination.update!(first_publication_year: "1977")

    assert_predicate Copyright::Determination::TermExpiration.new(determination), :applicable?
  end

  test "apply! declines a post-1977 publication without touching the determination" do
    determination = copyright_determinations(:trick_brain)
    determination.update!(first_publication_year: "1978")

    term_expiration = Copyright::Determination::TermExpiration.new(determination)
    assert_not term_expiration.applicable?
    assert_not term_expiration.apply!
    assert_equal "researching", determination.reload.status
    assert_nil determination.basis
    assert_nil determination.public_domain_on
  end

  test "not applicable without a known first publication year" do
    determination = copyright_determinations(:trick_brain)
    determination.update!(first_publication_year: nil)

    term_expiration = Copyright::Determination::TermExpiration.new(determination)
    assert_not term_expiration.applicable?
    assert_nil term_expiration.expires_on
  end
end
