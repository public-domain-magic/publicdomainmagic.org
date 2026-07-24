# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::Determination::VerdictTest < ActiveSupport::TestCase
  test "a fully-run term is public domain, determined, with its computed date" do
    travel_to Date.new(2026, 7, 1) do
      verdict = assess("1901")

      assert_equal :public_domain, verdict
      assert_equal "determined", @determination.status
      assert_equal "term_expired", @determination.basis
      assert_equal Date.new(1997, 1, 1), @determination.public_domain_on
      assert_predicate @determination, :public_domain?
    end
  end

  test "a 1978-or-later work is determined not public domain, without a fake date" do
    verdict = assess("1978")

    assert_equal :not_public_domain, verdict
    assert_equal "determined", @determination.status
    assert_nil @determination.basis
    assert_nil @determination.public_domain_on
    assert_not @determination.public_domain?
  end

  test "the uncertain middle needs Rule 6 research" do
    travel_to Date.new(2026, 7, 1) do
      verdict = assess("1948")

      assert_equal :needs_research, verdict
      assert_equal "researching", @determination.status
      assert_nil @determination.public_domain_on
    end
  end

  test "a pre-1978 work whose term has just run is public domain" do
    travel_to Date.new(2026, 7, 1) do
      # 1930 + 96 = 2026-01-01, which has arrived by July 2026.
      assert_equal :public_domain, assess("1930")
    end
  end

  test "the same pre-1978 work still needs research the year before its term runs" do
    travel_to Date.new(2025, 7, 1) do
      # 1930 + 96 = 2026-01-01 has not arrived yet in 2025.
      assert_equal :needs_research, assess("1930")
    end
  end

  test "no verdict is offered when no year is known" do
    verdict = assess(nil)

    assert_nil verdict
    assert_equal "researching", @determination.reload.status, "left untouched"
  end

  private def assess(year)
    @determination = copyright_determinations(:trick_brain)
    @determination.update!(first_publication_year: year)
    Copyright::Determination::Verdict.new(@determination).assess!
  end
end
