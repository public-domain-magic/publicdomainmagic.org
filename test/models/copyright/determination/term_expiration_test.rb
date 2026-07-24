# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::Determination::TermExpirationTest < ActiveSupport::TestCase
  test "a term that has fully run settles the work public domain" do
    travel_to Date.new(2026, 7, 1) do
      determination = copyright_determinations(:trick_brain)
      determination.update!(first_publication_year: "1930")
      term_expiration = Copyright::Determination::TermExpiration.new(determination)

      assert_predicate term_expiration, :expired?
      assert term_expiration.apply!
      assert_equal "term_expired", determination.basis
      assert_equal "determined", determination.status
      assert_equal Date.new(2026, 1, 1), determination.public_domain_on
    end
  end

  test "a pre-1978 term still running is not settled by expiry alone" do
    travel_to Date.new(2026, 7, 1) do
      determination = copyright_determinations(:trick_brain)
      determination.update!(first_publication_year: "1948")
      term_expiration = Copyright::Determination::TermExpiration.new(determination)

      assert_predicate term_expiration, :applicable?, "still within the pre-1978 regime"
      assert_not term_expiration.expired?, "the 95-year term has not run yet"
      assert_not term_expiration.apply!
      assert_equal "researching", determination.reload.status
      assert_nil determination.basis
      assert_nil determination.public_domain_on
      assert_equal Date.new(2044, 1, 1), term_expiration.expires_on
    end
  end

  test "an EDTF range counts from its start year" do
    determination = copyright_determinations(:trick_brain)
    determination.update!(first_publication_year: "1924/1928")

    term_expiration = Copyright::Determination::TermExpiration.new(determination)
    assert_predicate term_expiration, :applicable?
    assert_equal Date.new(2020, 1, 1), term_expiration.expires_on
    assert_equal 1924, term_expiration.year
  end

  test "the regime covers first publication through 1977" do
    determination = copyright_determinations(:trick_brain)
    determination.update!(first_publication_year: "1977")

    assert_predicate Copyright::Determination::TermExpiration.new(determination), :applicable?
  end

  test "the regime excludes a post-1977 publication" do
    determination = copyright_determinations(:trick_brain)
    determination.update!(first_publication_year: "1978")

    term_expiration = Copyright::Determination::TermExpiration.new(determination)
    assert_not term_expiration.applicable?
    assert_not term_expiration.expired?
    assert_not term_expiration.apply!
    assert_equal "researching", determination.reload.status
  end

  test "nothing is applicable without a known first publication year" do
    determination = copyright_determinations(:trick_brain)
    determination.update!(first_publication_year: nil)

    term_expiration = Copyright::Determination::TermExpiration.new(determination)
    assert_not term_expiration.applicable?
    assert_not term_expiration.expired?
    assert_nil term_expiration.expires_on
    assert_nil term_expiration.year
  end
end
