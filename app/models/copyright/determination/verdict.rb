# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The copyright status the system can compute from a first-publication year
# alone, by date math against today — never demanded, never invented. Three
# outcomes, plus "no verdict" when no year is known:
#
# - +:public_domain+ — the 95-year term has fully run (published on or before
#   January 1 of this year minus 95); certain regardless of renewal.
# - +:not_public_domain+ — first published in 1978 or later; the term is
#   nowhere near run. A precise public-domain date may be uncomputable without
#   a death date, so the verdict is recorded without a fabricated date.
# - +:needs_research+ — the uncertain middle (a pre-1978 year whose term has
#   not yet run), where notice and renewal decide: the separate Rule 6 track.
#
# Because the public-domain line is arithmetic against today, the
# +:needs_research+ band shrinks on its own every January 1.
class Copyright::Determination::Verdict
  # Takes the Copyright::Determination being assessed.
  def initialize(determination)
    @determination = determination
  end

  # The computed outcome symbol, or +nil+ when no first-publication year is
  # known (no verdict is offered — the exterior-photo case). Pure: computes
  # without touching the determination.
  def outcome
    published_in = year
    return nil if published_in.nil?
    return :public_domain if term_expiration.expired?
    return :not_public_domain if published_in > Copyright::Determination::TermExpiration::FINAL_YEAR

    :needs_research
  end

  # Records the verdict on the determination and returns the outcome symbol:
  # a public-domain term expiry (with its computed date), a determined
  # not-public-domain (no fabricated date), or an open +researching+ status
  # for the Rule 6 band. Does nothing and returns +nil+ when no year is known.
  def assess!
    case outcome
    when :public_domain
      term_expiration.apply!
    when :not_public_domain
      @determination.update!(status: :determined, basis: nil, public_domain_on: nil)
    when :needs_research
      @determination.update!(status: :researching, basis: nil, public_domain_on: nil)
    end
    outcome
  end

  private def term_expiration
    @term_expiration ||= Copyright::Determination::TermExpiration.new(@determination)
  end

  private def year
    term_expiration.year
  end
end
